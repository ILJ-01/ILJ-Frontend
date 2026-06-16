import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Calendar, Plus, Trash2, Edit2, X, Check, MapPin, Clock } from 'lucide-react';

export default function AdminRevaSessions() {
    const [sessions, setSessions] = useState([]);
    const [loading, setLoading] = useState(true);
    const [isFormOpen, setIsFormOpen] = useState(false);
    const [editingId, setEditingId] = useState(null);
    const [formData, setFormData] = useState({ date: '', time: '', venue: '' });
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        fetchSessions();
    }, []);

    const fetchSessions = async () => {
        try {
            setLoading(true);
            const { data, error } = await supabase
                .from('reva_sessions')
                .select('*')
                .order('date', { ascending: true })
                .order('time', { ascending: true });

            if (error) throw error;
            setSessions(data || []);
        } catch (err) {
            console.error('Error fetching REVA sessions:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleOpenForm = (session = null) => {
        if (session) {
            setEditingId(session.id);
            setFormData({ date: session.date, time: session.time.substring(0, 5), venue: session.venue });
        } else {
            setEditingId(null);
            setFormData({ date: '', time: '', venue: '' });
        }
        setIsFormOpen(true);
    };

    const handleCloseForm = () => {
        setIsFormOpen(false);
        setEditingId(null);
        setFormData({ date: '', time: '', venue: '' });
    };

    const formatTime12h = (timeStr) => {
        if (!timeStr) return '';
        const [hours, minutes] = timeStr.split(':');
        const h = parseInt(hours, 10);
        const ampm = h >= 12 ? 'PM' : 'AM';
        const h12 = h % 12 || 12;
        return `${h12}:${minutes} ${ampm}`;
    };

    const handleSessionSubmit = async (e) => {
        if (e) e.preventDefault();
        try {
            setSaving(true);
            if (editingId) {
                const { error } = await supabase
                    .from('reva_sessions')
                    .update(formData)
                    .eq('id', editingId);
                if (error) throw error;
            } else {
                const { error } = await supabase
                    .from('reva_sessions')
                    .insert([formData]);
                if (error) throw error;

                // Send notifications to all volunteers
                try {
                    const { data: allVols } = await supabase
                        .from('volunteers')
                        .select('id');
                    
                    if (allVols && allVols.length > 0) {
                        const formattedDate = new Date(formData.date).toLocaleDateString('en-IN', { day: 'numeric', month: 'long', year: 'numeric' });
                        const formattedTime = formatTime12h(formData.time);
                        const notificationsToInsert = allVols.map(vol => ({
                            user_id: vol.id,
                            message: `New REVA Event Scheduled:\nDate: ${formattedDate}\nTime: ${formattedTime}\nVenue: ${formData.venue}`,
                            type: 'reva_event',
                            is_read: false
                        }));

                        // Chunk insertions
                        const chunkSize = 100;
                        for (let i = 0; i < notificationsToInsert.length; i += chunkSize) {
                            const chunk = notificationsToInsert.slice(i, i + chunkSize);
                            await supabase.from('notifications').insert(chunk);
                        }
                    }
                } catch (notiErr) {
                    console.error('Failed to dispatch notifications:', notiErr);
                }
            }
            fetchSessions();
            handleCloseForm();
        } catch (err) {
            alert(`Error saving session: ${err.message}`);
        } finally {
            setSaving(false);
        }
    };

    const handleDelete = async (id) => {
        if (!window.confirm("Are you sure you want to delete this session?")) return;
        try {
            const { error } = await supabase.from('reva_sessions').delete().eq('id', id);
            if (error) throw error;
            setSessions(sessions.filter(s => s.id !== id));
        } catch (err) {
            alert(`Error deleting session: ${err.message}`);
        }
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            <div className="flex justify-between items-center bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
                <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                        <Calendar className="h-6 w-6 text-[#ae2b2b]" /> REVA Schedule Management
                    </h2>
                    <p className="text-sm text-gray-500">Add, edit or remove upcoming REVA sessions.</p>
                </div>
                <button
                    type="button"
                    onClick={() => handleOpenForm()}
                    className="bg-[#ae2b2b] hover:bg-[#8b1e1e] text-white px-4 py-2 rounded-lg font-medium flex items-center gap-2 transition-colors shadow-sm"
                >
                    <Plus className="h-4 w-4" /> Add Session
                </button>
            </div>

            {isFormOpen && (
                <div className="bg-white p-5 rounded-xl border border-gray-200 shadow-md animate-in fade-in slide-in-from-top-4">
                    <div className="flex justify-between items-center mb-4 pb-3 border-b border-gray-100">
                        <h3 className="font-bold text-lg text-gray-900">{editingId ? 'Edit Session' : 'New Session'}</h3>
                        <button type="button" onClick={handleCloseForm} className="text-gray-400 hover:text-gray-600">
                            <X className="h-5 w-5" />
                        </button>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label className="block text-sm font-bold text-gray-700 mb-1">Date</label>
                            <input 
                                type="date" required 
                                className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                value={formData.date} onChange={e => setFormData({...formData, date: e.target.value})}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-bold text-gray-700 mb-1">Time</label>
                            <input 
                                type="time" required 
                                className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                value={formData.time} onChange={e => setFormData({...formData, time: e.target.value})}
                            />
                        </div>
                        <div className="md:col-span-3">
                            <label className="block text-sm font-bold text-gray-700 mb-1">Venue</label>
                            <input 
                                type="text" required placeholder="Full venue address"
                                className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                value={formData.venue} onChange={e => setFormData({...formData, venue: e.target.value})}
                            />
                        </div>
                        <div className="md:col-span-3 flex justify-end gap-3 mt-2">
                            <button type="button" onClick={handleCloseForm} className="px-4 py-2 text-gray-600 border rounded-lg hover:bg-gray-50 font-medium">Cancel</button>
                            <button type="button" onClick={handleSessionSubmit} disabled={saving} className="px-5 py-2 bg-[#ae2b2b] text-white rounded-lg hover:bg-[#8b1e1e] font-medium flex items-center gap-2">
                                {saving ? <div className="animate-spin h-4 w-4 border-b-2 border-white rounded-full"></div> : <Check className="h-4 w-4" />}
                                {editingId ? 'Update Session' : 'Save Session'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            <div className="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
                {sessions.length === 0 ? (
                    <div className="text-center py-12">
                        <Calendar className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                        <h3 className="text-lg font-medium text-gray-900">No REVA sessions scheduled</h3>
                        <p className="text-gray-500">Click the 'Add Session' button to schedule one.</p>
                    </div>
                ) : (
                    <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                            <thead>
                                <tr className="bg-gray-50 border-b border-gray-200 text-xs uppercase tracking-wider text-gray-500 font-bold">
                                    <th className="p-4">Date</th>
                                    <th className="p-4">Time</th>
                                    <th className="p-4">Venue</th>
                                    <th className="p-4 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-gray-100">
                                {sessions.map(session => (
                                    <tr key={session.id} className="hover:bg-gray-50/50 transition-colors">
                                        <td className="p-4 whitespace-nowrap">
                                            <div className="flex items-center gap-2 font-medium text-gray-900">
                                                <Calendar className="h-4 w-4 text-[#ae2b2b]" />
                                                {new Date(session.date).toLocaleDateString('en-IN', { day: 'numeric', month: 'long', year: 'numeric' })}
                                            </div>
                                        </td>
                                        <td className="p-4 whitespace-nowrap">
                                            <div className="flex items-center gap-2 text-gray-600">
                                                <Clock className="h-4 w-4" />
                                                {formatTime12h(session.time)}
                                            </div>
                                        </td>
                                        <td className="p-4">
                                            <div className="flex items-center gap-2 text-gray-700">
                                                <MapPin className="h-4 w-4 shrink-0 text-gray-400" />
                                                <span className="line-clamp-2">{session.venue}</span>
                                            </div>
                                        </td>
                                        <td className="p-4 whitespace-nowrap text-right space-x-2">
                                            <button 
                                                type="button"
                                                onClick={() => handleOpenForm(session)}
                                                className="p-1.5 text-gray-500 hover:text-[#ae2b2b] hover:bg-red-50 rounded transition-colors"
                                            >
                                                <Edit2 className="h-4 w-4" />
                                            </button>
                                            <button 
                                                type="button"
                                                onClick={() => handleDelete(session.id)}
                                                className="p-1.5 text-red-600 hover:bg-red-50 rounded transition-colors"
                                            >
                                                <Trash2 className="h-4 w-4" />
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                )}
            </div>
        </div>
    );
}
