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
            setUser(data);
            localStorage.setItem('ilj_user', JSON.stringify(data));

            return { success: true, user: data };
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
            // Verify ILJ ID and email match
            const { data: volunteer, error: findError } = await supabase
                .from('volunteers')
                .select('id, ilj_id, email')
                .eq('ilj_id', iljId.toUpperCase())
                .eq('email', email.toLowerCase())
                .single();

            if (findError || !volunteer) {
                return { success: false, error: 'ILJ ID and Email do not match our records' };
            }

            // Update password
            const { error: updateError } = await supabase
                .from('volunteers')
                .update({ password_hash: newPassword })
                .eq('id', volunteer.id);

            if (updateError) {
                return { success: false, error: 'Failed to update password' };
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
            setUser(data);
            localStorage.setItem('ilj_user', JSON.stringify(data));
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
