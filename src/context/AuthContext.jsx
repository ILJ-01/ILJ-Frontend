import { createContext, useContext, useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        let active = true;

        const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
            if (session?.user) {
                const email = session.user.email;
                if (email === 'admin@ilovejinshasan.org') {
                    const adminUser = {
                        id: session.user.id,
                        email: email,
                        first_name: 'Admin',
                        last_name: 'User',
                        is_it_admin: true,
                        isITAdmin: true,
                        isAdmin: true,
                        managed_projects: []
                    };
                    if (active) {
                        setUser(adminUser);
                        localStorage.setItem('ilj_user', JSON.stringify(adminUser));
                        setLoading(false);
                    }
                } else {
                    // Try to load cached user first to be fast
                    const storedUser = localStorage.getItem('ilj_user');
                    if (storedUser) {
                        try {
                            const parsedUser = JSON.parse(storedUser);
                            if (parsedUser.email === email) {
                                if (active) {
                                    setUser(parsedUser);
                                    setLoading(false);
                                }
                            }
                        } catch (e) {}
                    }

                    // Then fetch fresh data
                    try {
                        const { data: userData, error } = await supabase
                            .from('volunteers')
                            .select('*')
                            .eq('email', email)
                            .single();
                        
                        if (active && userData && !error) {
                            // Fetch managed projects
                            const { data: projects } = await supabase
                                .from('projects')
                                .select('*')
                                .eq('manager_id', userData.id);
                            
                            const isManager = projects && projects.length > 0;
                            const isTeamLeader = userData.team_leader_for && userData.team_leader_for.trim() !== '';
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
                                managed_projects: projects || [],
                                isAdmin: isManager || isTeamLeader,
                                isManager,
                                isTeamLeader,
                                isKalyanMitra,
                                isITAdmin,
                                isOnboardingTeam,
                                isPodTeam
                            };

                            setUser(userWithProjects);
                            localStorage.setItem('ilj_user', JSON.stringify(userWithProjects));
                        }
                    } catch (e) {
                        console.error("Error restoring user profile from session:", e);
                    } finally {
                        if (active) {
                            setLoading(false);
                        }
                    }
                }
            } else {
                if (active) {
                    setUser(null);
                    localStorage.removeItem('ilj_user');
                    setLoading(false);
                }
            }
        });

        return () => {
            active = false;
            subscription.unsubscribe();
        };
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

            // Log in to standard Supabase Auth using the user's email and password
            const { error: authError } = await supabase.auth.signInWithPassword({
                email: userData.email,
                password: password
            });

            if (authError) {
                console.error('Supabase Auth sync error:', authError);
                return { success: false, error: `Authentication sync failed: ${authError.message}` };
            }

            // Check if user is a manager or team leader and add admin flag
            const isManager = userData.managed_projects && userData.managed_projects.length > 0;
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
                isAdmin: isManager || isTeamLeader,
                isManager,
                isTeamLeader,
                isKalyanMitra,
                isITAdmin,
                isOnboardingTeam,
                isPodTeam
            };

            setUser(userWithProjects);
            localStorage.setItem('ilj_user', JSON.stringify(userWithProjects));

            return { success: true, user: userWithProjects };
        } catch (error) {
            console.error('Login error:', error);
            return { success: false, error: 'An error occurred during login' };
        }
    };

    const logout = async () => {
        setUser(null);
        localStorage.removeItem('ilj_user');
        await supabase.auth.signOut();
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

            // Fetch Projects Managed by User (public data, no auth needed)
            const { data: projects, error: projectError } = await supabase
                .from('projects')
                .select('*')
                .eq('manager_id', currentUser.id);

            if (projectError) {
                console.error("Error fetching managed projects:", projectError);
            }

            // Check admin status
            const isManager = projects && projects.length > 0;
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
                isAdmin: isManager || isTeamLeader,
                isManager,
                isTeamLeader,
                isKalyanMitra,
                isITAdmin,
                isOnboardingTeam,
                isPodTeam
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
            isPodTeam: user?.isPodTeam || false
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
