import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/context/AuthContext';
import { Eye, EyeOff, Loader2, ArrowRight } from 'lucide-react';

import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog"
import {
    Tabs,
    TabsContent,
    TabsList,
    TabsTrigger,
} from "@/components/ui/tabs"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"

// Simple inline Alert component since we didn't confirm it exists in the list
const SimpleAlert = ({ type, message }) => (
    <div className={`p-3 rounded-md text-sm border ${type === 'error'
        ? 'bg-red-50 text-red-600 border-red-200'
        : 'bg-green-50 text-green-600 border-green-200'
        }`}>
        {message}
    </div>
);

export default function LoginModal({ isOpen, onClose }) {
    const navigate = useNavigate();
    const { login, updatePassword } = useAuth();

    // We'll map "activeTab" to Tabs value. 
    // "login" -> Login Form
    // "register" -> Register info
    // "reset" -> Password Reset (usually better as a separate flow, but we can keep it here)
    const [activeTab, setActiveTab] = useState("login");

    const [showPassword, setShowPassword] = useState(false);
    const [isLoading, setIsLoading] = useState(false);
    const [message, setMessage] = useState({ type: '', text: '' });

    // Forms state
    const [loginData, setLoginData] = useState({ iljId: '', password: '' });
    const [resetData, setResetData] = useState({ iljId: '', email: '', newPassword: '', confirmPassword: '' });

    const handleLogin = async (e) => {
        e.preventDefault();
        setIsLoading(true);
        setMessage({ type: '', text: '' });

        const result = await login(loginData.iljId, loginData.password);

        if (result.success) {
            setMessage({ type: 'success', text: 'Login successful!' });
            setTimeout(() => {
                onClose();
                if (window.innerWidth < 768) {
                    navigate('/dashboard/profile');
                } else {
                    navigate('/dashboard');
                }
            }, 500);
        } else {
            setMessage({ type: 'error', text: result.error });
        }

        setIsLoading(false);
    };

    const handleReset = async (e) => {
        e.preventDefault();
        setIsLoading(true);
        setMessage({ type: '', text: '' });

        if (resetData.newPassword !== resetData.confirmPassword) {
            setMessage({ type: 'error', text: 'Passwords do not match' });
            setIsLoading(false);
            return;
        }
        if (resetData.newPassword.length < 6) {
            setMessage({ type: 'error', text: 'Password must be at least 6 characters' });
            setIsLoading(false);
            return;
        }

        const result = await updatePassword(resetData.iljId, resetData.email, resetData.newPassword);

        if (result.success) {
            setMessage({ type: 'success', text: 'Password updated! Please login.' });
            setTimeout(() => {
                setActiveTab('login');
                setResetData({ iljId: '', email: '', newPassword: '', confirmPassword: '' });
            }, 2000);
        } else {
            setMessage({ type: 'error', text: result.error });
        }

        setIsLoading(false);
    };

    const handleRegisterRedirect = () => {
        onClose();
        navigate('/volunteer-registration');
    };

    // Reset state when modal closes
    const handleOpenChange = (open) => {
        if (!open) {
            onClose();
            // Optional: reset forms after a delay
            setTimeout(() => {
                setMessage({ type: '', text: '' });
                setActiveTab('login');
            }, 300);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={handleOpenChange}>
            <DialogContent className="sm:max-w-[425px] bg-white gap-0 p-0 overflow-hidden">
                <div className="p-6 pb-2">
                    <DialogHeader>
                        <DialogTitle className="text-2xl font-serif text-[#ae2b2b]">
                            {activeTab === 'login' && 'Welcome Back'}
                            {activeTab === 'register' && 'Join the Mission'}
                            {activeTab === 'reset' && 'Reset Password'}
                        </DialogTitle>
                        <DialogDescription className="text-gray-500">
                            {activeTab === 'login' && 'Enter your credentials to access your dashboard.'}
                            {activeTab === 'register' && 'Become a volunteer and contribute to Jinshasan.'}
                            {activeTab === 'reset' && 'Create a new password for your account.'}
                        </DialogDescription>
                    </DialogHeader>
                </div>

                <div className="px-6 pb-6">
                    <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
                        <TabsList className="grid w-full grid-cols-2 mb-6">
                            <TabsTrigger value="login">Login</TabsTrigger>
                            <TabsTrigger value="register">Register</TabsTrigger>
                        </TabsList>

                        {message.text && (
                            <div className="mb-4">
                                <SimpleAlert type={message.type} message={message.text} />
                            </div>
                        )}

                        <TabsContent value="login" className="space-y-4 data-[state=inactive]:hidden mt-0">
                            <form onSubmit={handleLogin} className="space-y-4">
                                <div className="space-y-2">
                                    <Label htmlFor="iljId">ILJ ID</Label>
                                    <Input
                                        id="iljId"
                                        placeholder="ILJ-XXX"
                                        value={loginData.iljId}
                                        onChange={(e) => setLoginData({ ...loginData, iljId: e.target.value })}
                                        required
                                        className="h-10"
                                    />
                                </div>
                                <div className="space-y-2">
                                    <div className="flex items-center justify-between">
                                        <Label htmlFor="password">Password</Label>
                                        <button
                                            type="button"
                                            onClick={() => setActiveTab('reset')}
                                            className="text-xs text-[#ae2b2b] hover:underline"
                                            tabIndex={-1}
                                        >
                                            Forgot password?
                                        </button>
                                    </div>
                                    <div className="relative">
                                        <Input
                                            id="password"
                                            type={showPassword ? "text" : "password"}
                                            placeholder="••••••••"
                                            value={loginData.password}
                                            onChange={(e) => setLoginData({ ...loginData, password: e.target.value })}
                                            required
                                            className="pr-10 h-10"
                                        />
                                        <button
                                            type="button"
                                            onClick={() => setShowPassword(!showPassword)}
                                            className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                                            tabIndex={-1}
                                        >
                                            {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                                        </button>
                                    </div>
                                </div>
                                <Button
                                    type="submit"
                                    className="w-full bg-[#ae2b2b] hover:bg-[#962525] text-white"
                                    disabled={isLoading}
                                >
                                    {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                                    Login
                                </Button>
                            </form>
                        </TabsContent>

                        <TabsContent value="register" className="space-y-4 data-[state=inactive]:hidden mt-0">
                            <div className="text-center space-y-4 py-4">
                                <div className="mx-auto w-12 h-12 rounded-full bg-red-50 flex items-center justify-center text-[#ae2b2b]">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-user-plus"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" /><circle cx="9" cy="7" r="4" /><line x1="19" y1="8" x2="19" y2="14" /><line x1="22" y1="11" x2="16" y2="11" /></svg>
                                </div>
                                <div className="space-y-2">
                                    <h3 className="font-medium text-gray-900">Join Our Community</h3>
                                    <p className="text-sm text-gray-500 max-w-xs mx-auto">
                                        Sign up to access volunteer resources, track your impact, and connect with others.
                                    </p>
                                </div>
                                <Button onClick={handleRegisterRedirect} className="w-full bg-white border border-[#ae2b2b] text-[#ae2b2b] hover:bg-red-50">
                                    Register Now
                                    <ArrowRight className="ml-2 h-4 w-4" />
                                </Button>
                            </div>
                        </TabsContent>

                        <TabsContent value="reset" className="space-y-4 data-[state=inactive]:hidden mt-0">
                            <div className="flex items-center mb-4">
                                <button
                                    onClick={() => setActiveTab('login')}
                                    className="text-sm text-gray-500 hover:text-gray-900 flex items-center"
                                >
                                    ← Back to Login
                                </button>
                            </div>
                            <form onSubmit={handleReset} className="space-y-4">
                                <div className="space-y-2">
                                    <Label htmlFor="resetIljId">ILJ ID</Label>
                                    <Input
                                        id="resetIljId"
                                        placeholder="ILJ-XXX"
                                        value={resetData.iljId}
                                        onChange={(e) => setResetData({ ...resetData, iljId: e.target.value })}
                                        required
                                        className="h-9"
                                    />
                                </div>
                                <div className="space-y-2">
                                    <Label htmlFor="resetEmail">Email</Label>
                                    <Input
                                        id="resetEmail"
                                        placeholder="name@example.com"
                                        type="email"
                                        value={resetData.email}
                                        onChange={(e) => setResetData({ ...resetData, email: e.target.value })}
                                        required
                                        className="h-9"
                                    />
                                </div>
                                <div className="grid grid-cols-2 gap-3">
                                    <div className="space-y-2">
                                        <Label htmlFor="newPassword">New Password</Label>
                                        <Input
                                            id="newPassword"
                                            type="password"
                                            value={resetData.newPassword}
                                            onChange={(e) => setResetData({ ...resetData, newPassword: e.target.value })}
                                            required
                                            minLength={6}
                                            className="h-9"
                                        />
                                    </div>
                                    <div className="space-y-2">
                                        <Label htmlFor="confirmPassword">Confirm</Label>
                                        <Input
                                            id="confirmPassword"
                                            type="password"
                                            value={resetData.confirmPassword}
                                            onChange={(e) => setResetData({ ...resetData, confirmPassword: e.target.value })}
                                            required
                                            className="h-9"
                                        />
                                    </div>
                                </div>
                                <Button
                                    type="submit"
                                    className="w-full bg-[#ae2b2b] hover:bg-[#962525] text-white"
                                    disabled={isLoading}
                                >
                                    {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                                    Reset Password
                                </Button>
                            </form>
                        </TabsContent>
                    </Tabs>
                </div>

            </DialogContent>
        </Dialog>
    );
}
