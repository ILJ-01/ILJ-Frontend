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
                setUser(JSON.parse(storedUser));
            } catch (e) {
                localStorage.removeItem('ilj_user');
            }
        }
        setLoading(false);
    }, []);

    const login = async (iljId, password) => {
        try {
            // Query volunteer by ILJ ID and password
            const { data, error } = await supabase
                .from('volunteers')
                .select('*')
                .eq('ilj_id', iljId.toUpperCase())
                .eq('password_hash', password)
                .single();

            if (error || !data) {
                return { success: false, error: 'Invalid ILJ ID or password' };
            }

            // Store user in state and localStorage
            // Fetch managed projects
            const { data: projects } = await supabase
                .from('projects')
                .select('*')
                .eq('manager_id', data.id);

            const userWithProjects = { ...data, managed_projects: projects || [] };

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
    };

    const updatePassword = async (iljId, email, newPassword) => {
        try {
            const { data, error } = await supabase
                .rpc('reset_volunteer_password', {
                    p_ilj_id: iljId,
                    p_email: email,
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

    const refreshUser = async () => {
        if (!user?.ilj_id) return;

        const { data, error } = await supabase
            .from('volunteers')
            .select('*')
            .eq('ilj_id', user.ilj_id)
            .single();

        if (!error && data) {
            const { data: projects } = await supabase
                .from('projects')
                .select('*')
                .eq('manager_id', data.id);

            const userWithProjects = { ...data, managed_projects: projects || [] };
            setUser(userWithProjects);
            localStorage.setItem('ilj_user', JSON.stringify(userWithProjects));
        }
    };

    return (
        <AuthContext.Provider value={{
            user,
            loading,
            login,
            logout,
            updatePassword,
            refreshUser,
            isLoggedIn: !!user
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
