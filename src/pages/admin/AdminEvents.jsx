
import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { Calendar, Plus, Search, Trash2, MapPin, X, Loader2, Edit, Users, Image as ImageIcon, ExternalLink, Mail, Phone, Clock } from 'lucide-react';

export default function AdminEvents() {
    const [events, setEvents] = useState([]);
    const [projects, setProjects] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [isEditing, setIsEditing] = useState(false);
    const [selectedEventId, setSelectedEventId] = useState(null);
    const [interestedVolunteers, setInterestedVolunteers] = useState([]);
    const [loadingVolunteers, setLoadingVolunteers] = useState(false);
    const [uploading, setUploading] = useState(false);

    // Form Data
    const [formData, setFormData] = useState({
        title: '', date: '', description: '', role_needed: '', project_id: '', banner_url: ''
    });

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        setLoading(true);
        // Fetch events with interest count
        const [eventsRes, projectsRes] = await Promise.all([
            supabase.from('events')
                .select('*, project:projects(title), event_interests(id)')
                .order('date', { ascending: true }),
            supabase.from('projects').select('id, title').order('title')
        ]);

        if (eventsRes.error) console.error(eventsRes.error);
        if (projectsRes.error) console.error(projectsRes.error);

        setEvents(eventsRes.data || []);
        setProjects(projectsRes.data || []);
        setLoading(false);
    };

    const fetchInterestedVolunteers = async (eventId) => {
        setLoadingVolunteers(true);
        const { data, error } = await supabase
            .from('event_interests')
            .select('volunteer:volunteers(*)')
            .eq('event_id', eventId);

        if (error) {
            console.error("Error fetching volunteers:", error);
            setInterestedVolunteers([]);
        } else {
            // Flatten the structure: data is [{ volunteer: {...} }, ...]
            setInterestedVolunteers(data.map(item => item.volunteer).filter(Boolean));
        }
        setLoadingVolunteers(false);
    };

    const handleEdit = (event) => {
        setIsEditing(true);
        setSelectedEventId(event.id);
        const dateStr = event.date ? new Date(event.date).toISOString().slice(0, 16) : ''; // Format for datetime-local
        setFormData({
            title: event.title,
            date: dateStr,
            description: event.description || '',
            role_needed: event.role_needed || '',
            project_id: event.project_id || '',
            banner_url: event.banner_url || ''
        });

        // Fetch interested people
        fetchInterestedVolunteers(event.id);

        setShowModal(true);
    };

    const handleCreate = () => {
        setIsEditing(false);
        setSelectedEventId(null);
        setFormData({ title: '', date: '', description: '', role_needed: '', project_id: '', banner_url: '' });
        setInterestedVolunteers([]);
        setShowModal(true);
    };

    const handleDelete = async (id) => {
        if (!confirm("Are you sure you want to delete this event? This will check-off all interested volunteers too. Cannot be undone.")) return;

        try {
            await supabase.from('events').delete().eq('id', id);
            setEvents(prev => prev.filter(e => e.id !== id));
        } catch (error) {
            console.error(error);
            alert("Failed to delete event");
        }
    };

    const handleImageUpload = async (e) => {
        try {
            setUploading(true);
            const file = e.target.files[0];
            if (!file) return;

            const fileExt = file.name.split('.').pop();
            const fileName = `${Date.now()}.${fileExt}`;
            const filePath = `${fileName}`;

            const { error: uploadError } = await supabase.storage
                .from('event-banners')
                .upload(filePath, file);

            if (uploadError) {
                throw uploadError;
            }

            const { data } = supabase.storage
                .from('event-banners')
                .getPublicUrl(filePath);

            setFormData({ ...formData, banner_url: data.publicUrl });
        } catch (error) {
            console.error('Error uploading image:', error);
            alert('Error uploading image!');
        } finally {
            setUploading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const payload = {
                title: formData.title,
                date: formData.date,
                description: formData.description,
                role_needed: formData.role_needed,
                project_id: formData.project_id || null,
                banner_url: formData.banner_url || null
            };

            if (isEditing) {
                const { error } = await supabase.from('events').update(payload).eq('id', selectedEventId);
                if (error) throw error;
                alert("Event updated successfully!");
            } else {
                const { error } = await supabase.from('events').insert([payload]);
                if (error) throw error;
                alert("Event created successfully!");
            }

            setShowModal(false);
            fetchData();
        } catch (error) {
            console.error(error);
            alert(isEditing ? "Failed to update event" : "Failed to create event");
        }
    };

    return (
        <div className="space-y-6">
            <div className="flex justify-between items-center">
                <h2 className="text-xl font-bold text-gray-800">Events Management</h2>
                <button
                    onClick={handleCreate}
                    className="flex items-center gap-2 bg-[#ae2b2b] text-white px-4 py-2 rounded-lg hover:bg-[#8b1e1e] transition shadow-sm font-medium"
                >
                    <Plus className="h-4 w-4" /> Create Event
                </button>
            </div>

            {loading ? (
                <div className="flex justify-center p-12"><Loader2 className="h-8 w-8 animate-spin text-[#ae2b2b]" /></div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {events.map(event => (
                        <div
                            key={event.id}
                            onClick={() => handleEdit(event)}
                            className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden hover:shadow-md transition-all flex flex-col group relative cursor-pointer"
                        >
                            {/* Banner or Placeholder */}
                            <div className="h-32 bg-gray-100 relative">
                                {event.banner_url ? (
                                    <img src={event.banner_url} alt={event.title} className="w-full h-full object-cover" />
                                ) : (
                                    <div className="w-full h-full flex items-center justify-center bg-[#ae2b2b]/5">
                                        <Calendar className="h-10 w-10 text-[#ae2b2b]/20" />
                                    </div>
                                )}
                                <div className="absolute top-2 right-2 flex gap-1">
                                    <button
                                        onClick={(e) => {
                                            e.stopPropagation();
                                            handleDelete(event.id);
                                        }}
                                        className="p-1.5 bg-white/90 text-gray-600 hover:text-red-500 rounded-lg shadow-sm backdrop-blur-sm transition-colors opacity-0 group-hover:opacity-100"
                                        title="Delete Event"
                                    >
                                        <Trash2 className="h-4 w-4" />
                                    </button>
                                </div>
                            </div>

                            <div className="p-4 flex-1 flex flex-col">
                                <div className="flex justify-between items-start mb-2">
                                    <h3 className="font-bold text-gray-900 line-clamp-1">{event.title}</h3>
                                </div>
                                <div className="flex items-center gap-2 text-xs text-gray-500 mb-3">
                                    <Clock className="h-3.5 w-3.5" />
                                    <span>{new Date(event.date).toLocaleDateString()} at {new Date(event.date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                                </div>

                                <p className="text-gray-600 text-sm line-clamp-2 mb-4 flex-1">{event.description}</p>

                                <div className="flex items-center justify-between border-t pt-3 mt-auto">
                                    <span className="text-xs bg-gray-100 px-2 py-1 rounded text-gray-600 font-medium">
                                        Role: {event.role_needed || 'Volunteer'}
                                    </span>
                                    <div className="flex items-center gap-1.5 text-xs font-semibold text-[#ae2b2b] bg-[#ae2b2b]/5 px-2.5 py-1 rounded-full">
                                        <Users className="h-3.5 w-3.5" />
                                        <span>{event.event_interests?.length || 0} Interested</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    ))}
                    {events.length === 0 && <p className="text-gray-500 col-span-full text-center py-10">No events found.</p>}
                </div>
            )}

            {/* Modal */}
            {showModal && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm overflow-y-auto">
                    <div className="bg-white w-full max-w-2xl rounded-2xl shadow-2xl animate-in fade-in zoom-in-95 my-8">
                        {/* Modal Header */}
                        <div className="flex justify-between items-center px-6 py-4 border-b border-gray-100 sticky top-0 bg-white rounded-t-2xl z-10">
                            <h3 className="text-xl font-bold text-gray-800">{isEditing ? 'Edit Event & View Interests' : 'Create New Event'}</h3>
                            <button onClick={() => setShowModal(false)}><X className="h-6 w-6 text-gray-400 hover:text-gray-600" /></button>
                        </div>

                        <div className="p-6">
                            <form onSubmit={handleSubmit} className="space-y-4">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label className="block text-sm font-medium mb-1">Event Title</label>
                                        <input required type="text" className="w-full border rounded-lg p-2" value={formData.title} onChange={e => setFormData({ ...formData, title: e.target.value })} />
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium mb-1">Date & Time</label>
                                        <input required type="datetime-local" className="w-full border rounded-lg p-2" value={formData.date} onChange={e => setFormData({ ...formData, date: e.target.value })} />
                                    </div>
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label className="block text-sm font-medium mb-1">Project (Optional)</label>
                                        <select className="w-full border rounded-lg p-2" value={formData.project_id} onChange={e => setFormData({ ...formData, project_id: e.target.value })}>
                                            <option value="">-- No Pod (General) --</option>
                                            {projects.map(p => <option key={p.id} value={p.id}>{p.title}</option>)}
                                        </select>
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium mb-1">Role Needed</label>
                                        <input type="text" placeholder="e.g. Photographer" className="w-full border rounded-lg p-2" value={formData.role_needed} onChange={e => setFormData({ ...formData, role_needed: e.target.value })} />
                                    </div>
                                </div>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Banner Image</label>
                                    <div className="space-y-2">
                                        {formData.banner_url && (
                                            <div className="w-full h-32 rounded-lg overflow-hidden border border-gray-200 relative group">
                                                <img src={formData.banner_url} alt="Banner" className="w-full h-full object-cover" />
                                                <button
                                                    type="button"
                                                    onClick={() => setFormData({ ...formData, banner_url: '' })}
                                                    className="absolute top-2 right-2 bg-red-500 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
                                                >
                                                    <X className="h-4 w-4" />
                                                </button>
                                            </div>
                                        )}
                                        <div className="flex gap-2">
                                            <label className={`flex - 1 flex items - center justify - center px - 4 py - 2 border border - gray - 300 border - dashed rounded - lg cursor - pointer hover: bg - gray - 50 transition - colors ${uploading ? 'opacity-50 cursor-not-allowed' : ''} `}>
                                                <div className="text-center">
                                                    {uploading ? (
                                                        <span className="flex items-center gap-2 text-sm text-gray-500"><Loader2 className="h-4 w-4 animate-spin" /> Uploading...</span>
                                                    ) : (
                                                        <span className="flex items-center gap-2 text-sm text-gray-500"><ImageIcon className="h-4 w-4" /> {formData.banner_url ? 'Change Image' : 'Upload Banner Image'}</span>
                                                    )}
                                                </div>
                                                <input
                                                    type="file"
                                                    className="hidden"
                                                    accept="image/*"
                                                    onChange={handleImageUpload}
                                                    disabled={uploading}
                                                />
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <label className="block text-sm font-medium mb-1">Description</label>
                                    <textarea required rows="3" className="w-full border rounded-lg p-2" value={formData.description} onChange={e => setFormData({ ...formData, description: e.target.value })}></textarea>
                                </div>

                                <button type="submit" className="w-full bg-[#ae2b2b] text-white font-bold py-2.5 rounded-lg hover:bg-[#8b1e1e]">
                                    {isEditing ? 'Update Event Details' : 'Create Event'}
                                </button>
                            </form>

                            {/* INTERESTED VOLUNTEERS SECTION (Only when Editing) */}
                            {isEditing && (
                                <div className="mt-8 pt-6 border-t border-gray-100">
                                    <div className="flex justify-between items-center mb-4">
                                        <h4 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                                            <Users className="h-5 w-5 text-[#ae2b2b]" />
                                            Interested Volunteers
                                            <span className="bg-[#ae2b2b]/10 text-[#ae2b2b] px-2 py-0.5 rounded-full text-xs">{interestedVolunteers.length}</span>
                                        </h4>
                                    </div>

                                    {loadingVolunteers ? (
                                        <div className="flex justify-center py-8"><Loader2 className="h-6 w-6 animate-spin text-gray-400" /></div>
                                    ) : interestedVolunteers.length === 0 ? (
                                        <div className="text-center py-6 bg-gray-50 rounded-lg border border-dashed border-gray-200">
                                            <p className="text-gray-500 text-sm">No one has shown interest yet.</p>
                                        </div>
                                    ) : (
                                        <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
                                            <table className="w-full text-sm text-left">
                                                <thead className="bg-gray-50 text-gray-500 font-medium">
                                                    <tr>
                                                        <th className="px-4 py-3">Name</th>
                                                        <th className="px-4 py-3">Contact</th>
                                                        <th className="px-4 py-3">Location</th>
                                                    </tr>
                                                </thead>
                                                <tbody className="divide-y divide-gray-100">
                                                    {interestedVolunteers.map(vol => (
                                                        <tr key={vol.id} className="hover:bg-gray-50/50">
                                                            <td className="px-4 py-3 font-medium text-gray-900">
                                                                <div>{vol.first_name} {vol.last_name}</div>
                                                                <div className="text-xs text-[#ae2b2b] font-normal">{vol.ilj_id}</div>
                                                            </td>
                                                            <td className="px-4 py-3">
                                                                <div className="flex items-center gap-1.5"><Mail className="h-3 w-3 text-gray-400" /> {vol.email}</div>
                                                                <div className="flex items-center gap-1.5 mt-0.5"><Phone className="h-3 w-3 text-gray-400" /> {vol.mobile_number}</div>
                                                            </td>
                                                            <td className="px-4 py-3 text-gray-600">
                                                                {vol.city}, {vol.district}
                                                            </td>
                                                        </tr>
                                                    ))}
                                                </tbody>
                                            </table>
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
