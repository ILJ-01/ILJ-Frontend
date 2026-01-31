import { useState, useEffect } from "react";
import { useAuth } from "@/context/AuthContext";
import { supabase } from "@/lib/supabase";
import { Calendar, MapPin, Clock } from "lucide-react";

export default function EventsPage() {
    const { user } = useAuth();
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [interestedEventIds, setInterestedEventIds] = useState(new Set());

    useEffect(() => {
        if (user) fetchEvents();
    }, [user]);

    const fetchEvents = async () => {
        setLoading(true);
        try {
            // Get start of today to include today's events even if they started earlier
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            // Fetch events and user's interests in parallel
            const [eventsRes, interestsRes] = await Promise.all([
                supabase
                    .from('events')
                    .select('*')
                    .gte('date', today.toISOString())
                    .order('date', { ascending: true }),
                supabase
                    .from('event_interests')
                    .select('event_id')
                    .eq('volunteer_id', user.id)
            ]);

            if (eventsRes.error) throw eventsRes.error;
            if (interestsRes.error) throw interestsRes.error;

            setEvents(eventsRes.data || []);
            setInterestedEventIds(new Set(interestsRes.data.map(i => i.event_id)));
        } catch (err) {
            console.error("Fetch Events Error:", err);
        } finally {
            setLoading(false);
        }
    };

    const handleVolunteer = async (eventId) => {
        try {
            const { error } = await supabase.from('event_interests').insert({
                event_id: eventId,
                volunteer_id: user.id
            });
            if (error) {
                if (error.code === '23505') alert("You have already marked your interest for this event.");
                else throw error;
            } else {
                alert("You're marked as interested");
                setInterestedEventIds(prev => new Set(prev).add(eventId));
            }
        } catch (e) {
            console.error("Volunteer Error:", e);
            alert("Action failed. Please try again.");
        }
    };

    const handleRevokeInterest = async (eventId) => {
        if (!confirm("Are you sure you want to revoke your interest for this event?")) return;
        try {
            const { error } = await supabase
                .from('event_interests')
                .delete()
                .eq('event_id', eventId)
                .eq('volunteer_id', user.id);

            if (error) throw error;

            alert("Interest revoked.");
            setInterestedEventIds(prev => {
                const updated = new Set(prev);
                updated.delete(eventId);
                return updated;
            });
        } catch (e) {
            console.error("Revoke Interest Error:", e);
            alert("Action failed. Please try again.");
        }
    };

    return (
        <div className="space-y-6">
            <div>
                <h2 className="text-2xl font-bold text-gray-900">Upcoming Events</h2>
                <p className="text-gray-500">Find opportunities to contribute and serve.</p>
            </div>

            {loading ? (
                <div className="flex justify-center p-12"><div className="animate-spin rounded-full h-10 w-10 border-b-2 border-[#ae2b2b]"></div></div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                    {events.length === 0 ? (
                        <div className="col-span-full text-center py-12 bg-white rounded-xl border border-dashed border-gray-300">
                            <Calendar className="h-12 w-12 text-gray-300 mx-auto mb-3" />
                            <p className="text-gray-500">No upcoming events at the moment.</p>
                        </div>
                    ) : (
                        events.map(event => {
                            const isInterested = interestedEventIds.has(event.id);
                            return (
                                <div key={event.id} className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden hover:shadow-md transition-all flex flex-col">
                                    <div className="h-48 bg-gray-100 relative group overflow-hidden">
                                        {event.banner_url ? (
                                            <img
                                                src={event.banner_url}
                                                alt={event.title}
                                                className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                                            />
                                        ) : (
                                            <div className="w-full h-full bg-[#ae2b2b]/5 flex items-center justify-center">
                                                <div className="text-center">
                                                    <span className="block text-3xl font-bold text-[#ae2b2b]">{new Date(event.date).getDate()}</span>
                                                    <span className="text-sm font-semibold uppercase text-[#ae2b2b] tracking-wider">
                                                        {new Date(event.date).toLocaleString('default', { month: 'long', year: 'numeric' })}
                                                    </span>
                                                </div>
                                            </div>
                                        )}
                                        {/* Date overlay when image is present */}
                                        {event.banner_url && (
                                            <div className="absolute top-3 right-3 bg-white/90 backdrop-blur-sm px-3 py-1.5 rounded-lg shadow-sm text-center min-w-[60px]">
                                                <span className="block text-xl font-bold text-gray-900 leading-none">{new Date(event.date).getDate()}</span>
                                                <span className="text-[10px] font-bold uppercase text-gray-600 leading-none">{new Date(event.date).toLocaleString('default', { month: 'short' })}</span>
                                            </div>
                                        )}
                                    </div>
                                    <div className="p-5 flex-1 flex flex-col">
                                        <h3 className="text-xl font-bold text-gray-900 mb-2">{event.title}</h3>
                                        <p className="text-gray-600 text-sm mb-4 line-clamp-3 flex-1">{event.description}</p>

                                        <div className="flex flex-col gap-2 mb-6">
                                            <div className="flex items-center gap-2 text-sm text-gray-500">
                                                <Clock className="h-4 w-4" />
                                                <span>
                                                    {new Date(event.date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                                </span>
                                            </div>
                                            {event.role_needed && (
                                                <div className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 w-fit">
                                                    Role: {event.role_needed}
                                                </div>
                                            )}
                                        </div>

                                        <button
                                            onClick={() => isInterested ? handleRevokeInterest(event.id) : handleVolunteer(event.id)}
                                            className={`w-full py-2.5 font-medium rounded-lg transition-colors shadow-sm ${isInterested
                                                ? "bg-red-50 text-red-600 border border-red-200 hover:bg-red-100"
                                                : "bg-[#ae2b2b] text-white hover:bg-[#8b1e1e]"
                                                }`}
                                        >
                                            {isInterested ? "✕ Revoke Interest" : "I am interested to volunteer"}
                                        </button>
                                    </div>
                                </div>
                            );
                        })
                    )}
                </div>
            )}
        </div>
    );
}
