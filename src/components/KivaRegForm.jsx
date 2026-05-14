import React, { useState } from 'react';
import { supabase } from '../lib/supabase';
import { Calendar, Search, CheckCircle, User, Phone, Briefcase } from 'lucide-react';
import { Button } from './ui/button';

export default function KivaRegForm({ projectId }) {
    const [isIljVolunteer, setIsIljVolunteer] = useState(null);
    const [iljId, setIljId] = useState('');
    const [fetchingVol, setFetchingVol] = useState(false);
    
    const [formData, setFormData] = useState({
        full_name: '',
        mobile_number: '',
    });
    
    const [selectedDate, setSelectedDate] = useState('');
    const [weekendString, setWeekendString] = useState('');
    
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [submitted, setSubmitted] = useState(false);
    const [errorMsg, setErrorMsg] = useState('');

    const handleDateChange = (e) => {
        const val = e.target.value;
        setSelectedDate(val);
        if (!val) {
            setWeekendString('');
            return;
        }

        const d = new Date(val);
        const day = d.getDay(); // 0 is Sunday, 6 is Saturday
        
        let saturday = new Date(d);
        let sunday = new Date(d);

        if (day === 0) { // Sunday
            saturday.setDate(d.getDate() - 1);
        } else if (day === 6) { // Saturday
            sunday.setDate(d.getDate() + 1);
        } else {
            // Pick upcoming weekend
            const daysUntilSaturday = 6 - day;
            saturday.setDate(d.getDate() + daysUntilSaturday);
            sunday.setDate(saturday.getDate() + 1);
        }

        const options = { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' };
        const satStr = saturday.toLocaleDateString('en-IN', options);
        const sunStr = sunday.toLocaleDateString('en-IN', options);
        
        setWeekendString(`${satStr} to ${sunStr}`);
    };

    const fetchVolunteer = async () => {
        if (!iljId.trim()) return;
        setFetchingVol(true);
        setErrorMsg('');
        try {
            const { data, error } = await supabase
                .from('volunteers')
                .select('first_name, last_name, mobile_number')
                .eq('ilj_id', iljId.trim().toUpperCase())
                .single();

            if (error || !data) {
                setErrorMsg('Volunteer not found. Please check your ILJ ID.');
            } else {
                setFormData({
                    full_name: `${data.first_name} ${data.last_name}`,
                    mobile_number: data.mobile_number || ''
                });
            }
        } catch (err) {
            setErrorMsg('Error fetching details.');
        } finally {
            setFetchingVol(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setErrorMsg('');

        if (!formData.full_name || !formData.mobile_number || !weekendString) {
            setErrorMsg('Please fill all required fields, including a preferred date.');
            return;
        }

        setIsSubmitting(true);
        try {
            const { error } = await supabase.from('kiva_registrations').insert([{
                project_id: projectId,
                is_ilj_volunteer: isIljVolunteer === true,
                ilj_id: isIljVolunteer ? iljId.trim().toUpperCase() : null,
                full_name: formData.full_name,
                mobile_number: formData.mobile_number,
                preferred_dates: weekendString
            }]);

            if (error) throw error;
            setSubmitted(true);
        } catch (err) {
            console.error(err);
            setErrorMsg('Registration failed. Please try again later.');
        } finally {
            setIsSubmitting(false);
        }
    };

    if (submitted) {
        return (
            <div className="bg-green-50 border border-green-200 rounded-xl p-8 text-center animate-in fade-in">
                <div className="mx-auto w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mb-4 shadow-sm">
                    <CheckCircle className="w-8 h-8 text-green-600" />
                </div>
                <h3 className="text-xl font-bold text-green-800 mb-2 font-serif">Registration Successful!</h3>
                <p className="text-green-700">Thank you for registering for KIVA. We have recorded your preferred weekend dates.</p>
                <p className="text-green-600 font-medium mt-2">{weekendString}</p>
            </div>
        );
    }

    return (
        <div className="bg-white rounded-2xl p-6 shadow-md border-t-4 border-[#ae2b2b]">
            <h3 className="text-xl font-bold text-gray-900 mb-4 font-serif flex items-center gap-2">
                <Briefcase className="h-5 w-5 text-[#ae2b2b]" /> KIVA Registration
            </h3>

            <div className="space-y-6">
                {/* Toggle Question */}
                <div className="bg-gray-50 p-4 rounded-xl border border-gray-200">
                    <p className="text-sm font-bold text-gray-800 mb-3">Are you registered with I Love Jinshasan as a volunteer?</p>
                    <div className="flex gap-4">
                        <label className={`flex-1 flex items-center justify-center gap-2 p-3 rounded-lg border-2 cursor-pointer transition-all ${isIljVolunteer === true ? 'border-[#ae2b2b] bg-red-50 text-[#ae2b2b]' : 'border-gray-200 bg-white text-gray-600 hover:border-gray-300'}`}>
                            <input 
                                type="radio" 
                                name="isIlj" 
                                checked={isIljVolunteer === true} 
                                onChange={() => { setIsIljVolunteer(true); setFormData({full_name: '', mobile_number: ''}); }} 
                                className="hidden" 
                            />
                            <span className="font-bold">YES</span>
                        </label>
                        <label className={`flex-1 flex items-center justify-center gap-2 p-3 rounded-lg border-2 cursor-pointer transition-all ${isIljVolunteer === false ? 'border-[#ae2b2b] bg-red-50 text-[#ae2b2b]' : 'border-gray-200 bg-white text-gray-600 hover:border-gray-300'}`}>
                            <input 
                                type="radio" 
                                name="isIlj" 
                                checked={isIljVolunteer === false} 
                                onChange={() => { setIsIljVolunteer(false); setFormData({full_name: '', mobile_number: ''}); setIljId(''); }} 
                                className="hidden" 
                            />
                            <span className="font-bold">NO</span>
                        </label>
                    </div>
                </div>

                {isIljVolunteer !== null && (
                    <form onSubmit={handleSubmit} className="space-y-5 animate-in fade-in slide-in-from-top-2">
                        {isIljVolunteer === true && (
                            <div className="space-y-1">
                                <label className="block text-sm font-semibold text-gray-700">ILJ ID</label>
                                <div className="flex gap-2">
                                    <input 
                                        type="text" 
                                        placeholder="e.g. ILJ-12345"
                                        value={iljId}
                                        onChange={(e) => setIljId(e.target.value)}
                                        className="flex-1 p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ae2b2b] outline-none font-medium uppercase"
                                    />
                                    <Button type="button" onClick={fetchVolunteer} disabled={fetchingVol || !iljId} className="bg-gray-800 hover:bg-gray-900 text-white px-4 shrink-0">
                                        {fetchingVol ? '...' : <Search className="w-5 h-5" />}
                                    </Button>
                                </div>
                            </div>
                        )}

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div className="space-y-1">
                                <label className="block text-sm font-semibold text-gray-700">Full Name</label>
                                <div className="relative">
                                    <User className="absolute left-3 top-3 h-5 w-5 text-gray-400" />
                                    <input 
                                        type="text" 
                                        required
                                        placeholder="Your name"
                                        value={formData.full_name}
                                        onChange={e => setFormData({...formData, full_name: e.target.value})}
                                        className="w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                        readOnly={isIljVolunteer && formData.full_name !== ''}
                                    />
                                </div>
                            </div>

                            <div className="space-y-1">
                                <label className="block text-sm font-semibold text-gray-700">Mobile Number</label>
                                <div className="relative">
                                    <Phone className="absolute left-3 top-3 h-5 w-5 text-gray-400" />
                                    <input 
                                        type="tel" 
                                        required
                                        placeholder="Mobile Number"
                                        value={formData.mobile_number}
                                        onChange={e => setFormData({...formData, mobile_number: e.target.value})}
                                        className="w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#ae2b2b] outline-none"
                                        readOnly={isIljVolunteer && formData.mobile_number !== ''}
                                    />
                                </div>
                            </div>
                        </div>

                        <div className="space-y-2 bg-amber-50 p-4 rounded-xl border border-amber-200">
                            <label className="block text-sm font-semibold text-amber-900">Preferred Weekend</label>
                            <p className="text-xs text-amber-700 mb-2">Select any date, and we'll automatically assign you to the weekend (Saturday & Sunday).</p>
                            <div className="relative">
                                <Calendar className="absolute left-3 top-3 h-5 w-5 text-amber-600" />
                                <input 
                                    type="date"
                                    required
                                    value={selectedDate}
                                    onChange={handleDateChange}
                                    className="w-full pl-10 pr-3 py-3 border border-amber-300 rounded-lg focus:ring-2 focus:ring-amber-500 outline-none text-gray-700"
                                />
                            </div>
                            {weekendString && (
                                <div className="mt-3 p-3 bg-white rounded-lg border border-amber-100 flex items-center justify-center gap-2">
                                    <CheckCircle className="w-4 h-4 text-green-600" />
                                    <span className="text-sm font-bold text-gray-800">{weekendString}</span>
                                </div>
                            )}
                        </div>

                        {errorMsg && <p className="text-red-600 text-sm font-medium text-center">{errorMsg}</p>}

                        <Button 
                            type="submit" 
                            disabled={isSubmitting} 
                            className="w-full py-6 text-lg font-bold bg-[#ae2b2b] hover:bg-[#8b1e1e] shadow-lg shadow-red-100 transition-all"
                        >
                            {isSubmitting ? 'Submitting...' : 'Register for KIVA'}
                        </Button>
                    </form>
                )}
            </div>
        </div>
    );
}
