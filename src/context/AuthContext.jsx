import { createContext, useContext, useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // Check for existing session in localStorage
        const storedUser = localStorage.getItem('ilj_user');
        if (storedUser) {
            try {
                const parsedUser = JSON.parse(storedUser);
                setUser(parsedUser);

                // Verify that Supabase Auth session is also active to keep them in sync.
                // If they logged in before the RLS fix, they won't have a Supabase Auth session.
                supabase.auth.getSession().then(({ data: { session } }) => {
                    if (!session && parsedUser.email !== 'admin@ilovejinshasan.org') {
                        console.warn("ILJ session exists but Supabase Auth session is missing. Logging out to resync...");
                        logout();
                    }
                });
            } catch (e) {
                localStorage.removeItem('ilj_user');
            }
        }
        setLoading(false);
    }, []);

    const login = async (iljId, password) => {
        try {
            const trimmedIljId = (iljId || '').trim();
            // Verify credentials against volunteers table via RPC
            const { data, error } = await supabase.rpc('login_volunteer', {
                p_ilj_id: trimmedIljId.toUpperCase(),
                p_password: password
            });

            if (error || !data || !data.success) {
                return { success: false, error: (data?.error) || 'Invalid ILJ ID or password' };
            }

            const userData = data.user;

            // Establish authenticated session with Supabase Auth
            let authResult = await supabase.auth.signInWithPassword({
                email: userData.email,
                password: password
            });

            // If auth sign in fails (e.g. auth user not synced or password out of sync), force sync and retry
            if (authResult.error) {
                console.warn("Auth sign in failed, attempting force sync...", authResult.error.message);
                const { data: syncData, error: syncError } = await supabase.rpc('force_sync_auth_password', {
                    p_ilj_id: trimmedIljId.toUpperCase(),
                    p_password: password
                });

                if (syncError || !syncData?.success) {
                    console.error("Force sync failed:", syncError || syncData?.error);
                    return { success: false, error: authResult.error.message || 'Authentication session setup failed' };
                }

                // Retry sign in after successful sync
                authResult = await supabase.auth.signInWithPassword({
                    email: userData.email,
                    password: password
                });

                if (authResult.error) {
                    console.error("Auth sign in retry failed:", authResult.error);
                    return { success: false, error: authResult.error.message || 'Authentication session retry failed' };
                }
            }

            const upperIljId = (userData.ilj_id || '').trim().toUpperCase();
            const isCPOrVCP = ['ILJ-001', 'ILJ-002', 'ILJ-007'].includes(upperIljId);

            // Check if user is a manager or team leader and add admin flag
            const isManager = (userData.managed_projects && userData.managed_projects.length > 0) || isCPOrVCP;
            const isTeamLeader = userData.team_leader_for && userData.team_leader_for.trim() !== '';

            // Check if user is a Kalyan Mitra
            const fullName = `${userData.first_name} ${userData.last_name}`.trim();
            const { count: kmCount } = await supabase
                .from('volunteers')
                .select('*', { count: 'exact', head: true })
                .ilike('kalyan_mitra', `%${fullName}%`);

            const isKalyanMitra = kmCount > 0;

            const isITAdmin = Boolean(userData.is_it_admin);
            const isOnboardingTeam = Boolean(userData.is_onboarding_team);
            const isPodTeam = Boolean(userData.is_pod_team);

            const userWithProjects = {
                ...userData,
                managed_projects: userData.managed_projects || [],
                isAdmin: isManager || isTeamLeader || isITAdmin,
                isManager,
                isTeamLeader,
                isKalyanMitra,
                isITAdmin,
                isOnboardingTeam,
                isPodTeam,
                isCPOrVCP
            };

            setUser(userWithProjects);
            localStorage.setItem('ilj_user', JSON.stringify(userWithProjects));

            return { success: true, user: userWithProjects };
        } catch (error) {
            console.error('Login error:', error);
            return { success: false, error: 'An error occurred during login' };
        }
    };

    const logout = () => {
        setUser(null);
        localStorage.removeItem('ilj_user');
        supabase.auth.signOut().catch(err => console.error("Error signing out of Supabase auth:", err));
    };

    const updatePassword = async (iljId, email, newPassword) => {
        try {
            const trimmedIljId = (iljId || '').trim();
            const trimmedEmail = (email || '').trim();
            const { data, error } = await supabase
                .rpc('reset_volunteer_password', {
                    p_ilj_id: trimmedIljId,
                    p_email: trimmedEmail,
                    p_new_password: newPassword
                });

            if (error) {
                console.error('RPC Error:', error);
                return { success: false, error: 'Failed to request password reset. Please try again.' };
            }

            if (!data.success) {
                return { success: false, error: data.error };
            }

            return { success: true, message: 'Password updated successfully' };
        } catch (error) {
            console.error('Password reset error:', error);
            return { success: false, error: 'An error occurred' };
        }
    };

    // Function to refresh user data (especially managed projects)
    const refreshUser = async () => {
        const currentUser = user || JSON.parse(localStorage.getItem('ilj_user'));
        if (!currentUser?.id) return;
        if (currentUser.email === 'admin@ilovejinshasan.org') return;

        try {
            // Fetch the updated volunteer profile
            const { data: updatedUserData, error: userError } = await supabase
                .from('volunteers')
                .select('*')
                .eq('id', currentUser.id)
                .single();

            if (userError) {
                console.error("Error fetching updated user data:", userError);
            }

            const mergedUser = updatedUserData || currentUser;

            // Fetch Projects Managed by User (where user is manager OR sub-head)
            const { data: projects, error: projectError } = await supabase
                .from('projects')
                .select('*')
                .or(`manager_id.eq.${currentUser.id},sub_head_ids.cs.{${currentUser.id}}`);

            if (projectError) {
                console.error("Error fetching managed projects:", projectError);
            }

            const upperIljId = (mergedUser.ilj_id || '').trim().toUpperCase();
            const isCPOrVCP = ['ILJ-001', 'ILJ-002', 'ILJ-007'].includes(upperIljId);

            // Check admin status
            const isManager = (projects && projects.length > 0) || isCPOrVCP;
            const isTeamLeader = mergedUser.team_leader_for && mergedUser.team_leader_for.trim() !== '';


            // Count if user is kalyan mitra
            const fullName = `${mergedUser.first_name || ''} ${mergedUser.last_name || ''}`.trim();
            const { count: kmCount } = await supabase
                .from('volunteers')
                .select('*', { count: 'exact', head: true })
                .ilike('kalyan_mitra', `%${fullName}%`);

            const isKalyanMitra = kmCount > 0;

            const isITAdmin = Boolean(mergedUser.is_it_admin);
            const isOnboardingTeam = Boolean(mergedUser.is_onboarding_team);
            const isPodTeam = Boolean(mergedUser.is_pod_team);

            // Merge: Current details + Managed Projects + Admin flags
            const updatedUser = {
                ...mergedUser,
                managed_projects: projects || currentUser.managed_projects || [],
                isAdmin: isManager || isTeamLeader || isITAdmin,
                isManager,
                isTeamLeader,
                isKalyanMitra,
                isITAdmin,
                isOnboardingTeam,
                isPodTeam,
                isCPOrVCP
            };

            setUser(updatedUser);
            localStorage.setItem('ilj_user', JSON.stringify(updatedUser));

        } catch (error) {
            console.error("Error refreshing user context:", error);
        }
    };

    // Refresh on mount to ensure permissions are up to date
    useEffect(() => {
        if (user) {
            refreshUser();
        }
    }, [user?.id]);

    return (
        <AuthContext.Provider value={{
            user,
            loading,
            login,
            logout,
            updatePassword,
            refreshUser,
            isLoggedIn: !!user,
            isAdmin: user?.isAdmin || false,
            isManager: user?.isManager || false,
            isTeamLeader: user?.isTeamLeader || false,
            isKalyanMitra: user?.isKalyanMitra || false,
            isITAdmin: user?.isITAdmin || false,
            isOnboardingTeam: user?.isOnboardingTeam || false,
            isPodTeam: user?.isPodTeam || false,
            isCPOrVCP: user?.isCPOrVCP || false
        }}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
}
