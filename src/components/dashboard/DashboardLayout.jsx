import { useState, useEffect } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import {
    Home, Calendar, CheckSquare, Clock, User, LogOut,
    Menu, X, Bell, Briefcase, FileText
} from "lucide-react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";

export default function DashboardLayout({ children }) {
    const [isOpen, setIsOpen] = useState(true);
    const [isMobile, setIsMobile] = useState(false);
    const location = useLocation();
    const navigate = useNavigate();
    const { user, logout } = useAuth();
    const [notifications, setNotifications] = useState([]);
    const [showNotifications, setShowNotifications] = useState(false);

    useEffect(() => {
        const handleResize = () => {
            if (window.innerWidth < 768) {
                setIsMobile(true);
                setIsOpen(false);
            } else {
                setIsMobile(false);
                setIsOpen(true);
            }
        };

        handleResize();
        window.addEventListener("resize", handleResize);
        return () => window.removeEventListener("resize", handleResize);
    }, []);

    useEffect(() => {
        if (user?.id) {
            fetchNotifications();
        }
    }, [user]);

    const fetchNotifications = async () => {
        const { data } = await supabase
            .from('notifications')
            .select('*')
            .eq('user_id', user.id)
            .eq('is_read', false)
            .order('created_at', { ascending: false });

        if (data) setNotifications(data);
    };

    const handleLogout = () => {
        logout();
        navigate('/');
    };

    const markRead = async (id) => {
        await supabase.from('notifications').update({ is_read: true }).eq('id', id);
        setNotifications(prev => prev.filter(n => n.id !== id));
    };

    const menuItems = [
        { icon: Calendar, label: "Events", path: "/dashboard/events" },
        { icon: CheckSquare, label: "Tasks", path: "/dashboard/tasks" },
        { icon: Clock, label: "Timesheet", path: "/dashboard/timesheet" },
        { icon: User, label: "My Profile", path: "/dashboard/profile" },
        { icon: FileText, label: "Policies", path: "/dashboard/policies" },

    ];

    if (user?.managed_projects?.length > 0) {
        menuItems.unshift({ icon: Briefcase, label: "Manager Hub", path: "/dashboard/manager" });
    }

    return (
        <div className="min-h-screen bg-gray-50 flex font-sans">
            {/* Sidebar */}
            <aside
                className={`fixed md:sticky top-0 h-screen bg-white border-r border-gray-200 z-40 transition-all duration-300 flex flex-col
        ${isOpen ? "w-56" : "w-20"} ${isMobile && !isOpen ? "-translate-x-full" : "translate-x-0"}`}
            >
                <div className="p-4 border-b border-gray-100 flex items-center justify-between h-16">
                    <div className="flex items-center gap-2 overflow-hidden">
                        {isOpen && <span className="text-xl font-bold text-[#ae2b2b] whitespace-nowrap">ILJ Volunteers</span>}
                        {!isOpen && <span className="text-xl font-bold text-[#ae2b2b] w-full text-center">ILJ</span>}
                    </div>
                    {isMobile && (
                        <button onClick={() => setIsOpen(false)} className="md:hidden">
                            <X className="h-6 w-6 text-gray-500" />
                        </button>
                    )}
                </div>

                <nav className="flex-1 py-6 px-3 space-y-2">
                    {menuItems.map((item) => {
                        const Icon = item.icon;
                        const isActive = location.pathname === item.path || (item.path !== '/dashboard' && location.pathname.startsWith(item.path));

                        return (
                            <Link
                                key={item.path}
                                to={item.path}
                                className={`flex items-center gap-3 px-3 py-3 rounded-lg transition-colors group relative
                  ${isActive ? "bg-[#ae2b2b]/5 text-[#ae2b2b]" : "text-gray-600 hover:bg-gray-100 hover:text-gray-900"}
                `}
                                title={!isOpen ? item.label : ""}
                            >
                                <Icon className={`h-6 w-6 flex-shrink-0 ${isActive ? "text-[#ae2b2b]" : "text-gray-400 group-hover:text-[#ae2b2b]"}`} />
                                {isOpen && <span className="font-medium whitespace-nowrap">{item.label}</span>}
                            </Link>
                        );
                    })}
                </nav>

                <div className="p-4 border-t border-gray-100">
                    <button
                        onClick={handleLogout}
                        className={`flex items-center gap-3 px-3 py-3 w-full rounded-lg text-red-600 hover:bg-red-50 transition-colors
              ${!isOpen ? "justify-center" : ""}
            `}
                    >
                        <LogOut className="h-6 w-6 flex-shrink-0" />
                        {isOpen && <span className="font-medium">Logout</span>}
                    </button>
                </div>
            </aside>

            {/* Overlay for mobile */}
            {isMobile && isOpen && (
                <div
                    className="fixed inset-0 bg-black/50 z-30"
                    onClick={() => setIsOpen(false)}
                />
            )}

            {/* Main Content */}
            <div className="flex-1 flex flex-col min-w-0">
                {/* Top Header */}
                <header className="bg-white border-b border-gray-200 h-16 flex items-center justify-between px-4 sticky top-0 z-30">
                    <div className="flex items-center gap-4">
                        <button onClick={() => setIsOpen(!isOpen)} className="p-2 hover:bg-gray-100 rounded-lg text-gray-600">
                            <Menu className="h-6 w-6" />
                        </button>
                        <h1 className="text-xl font-semibold text-gray-800 truncate">
                            {menuItems.find(i => i.path === location.pathname)?.label || 'Dashboard'}
                        </h1>
                    </div>

                    <div className="flex items-center gap-4">
                        <div className="relative">
                            <button
                                onClick={() => setShowNotifications(!showNotifications)}
                                className="p-2 hover:bg-gray-100 rounded-full relative"
                            >
                                <Bell className="h-6 w-6 text-gray-600" />
                                {notifications.length > 0 && (
                                    <span className="absolute top-1 right-1 w-2.5 h-2.5 bg-red-500 rounded-full border border-white"></span>
                                )}
                            </button>

                            {showNotifications && (
                                <div className="absolute right-0 mt-2 w-80 bg-white shadow-xl rounded-xl border border-gray-100 py-2 z-50">
                                    <div className="px-4 py-2 border-b border-gray-100 flex justify-between items-center">
                                        <h3 className="font-semibold text-sm">Notifications</h3>
                                        <button onClick={() => setNotifications([])} className="text-xs text-blue-600 hover:underline">Clear all</button>
                                    </div>
                                    {notifications.length === 0 ? (
                                        <div className="px-4 py-6 text-center text-gray-500 text-sm">No new notifications</div>
                                    ) : (
                                        <div className="max-h-80 overflow-y-auto">
                                            {notifications.map(n => (
                                                <div key={n.id} className="px-4 py-3 hover:bg-gray-50 border-b border-gray-50 last:border-0 cursor-pointer" onClick={() => markRead(n.id)}>
                                                    <p className="text-sm text-gray-800">{n.message}</p>
                                                    <span className="text-xs text-gray-400 mt-1 block">{new Date(n.created_at).toLocaleDateString()}</span>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>

                        <div className="flex items-center gap-3 pl-4 border-l border-gray-200">
                            <div className="w-8 h-8 rounded-full bg-[#ae2b2b]/10 flex items-center justify-center text-[#ae2b2b] font-bold border border-[#ae2b2b]/20">
                                {user?.first_name?.[0]}
                            </div>
                            <div className="hidden md:block">
                                <p className="text-sm font-medium text-gray-900 leading-none">{user?.first_name}</p>
                                <p className="text-xs text-gray-500 mt-1">{user?.ilj_id}</p>
                            </div>
                        </div>
                    </div>
                </header>

                <main className="flex-1 overflow-auto p-4 md:p-8">
                    {children}
                </main>
            </div>
        </div>
    );
}
