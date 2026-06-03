import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import { BookOpen, User, Phone, Mail, MapPin, Building, ShieldCheck, ArrowLeft, CheckCircle } from 'lucide-react';

export default function LibraryRegistrationPage() {
    const navigate = useNavigate();
    const [submitting, setSubmitting] = useState(false);
    const [submitted, setSubmitted] = useState(false);

    const [form, setForm] = useState({
        name: '',
        sangh_name: '',
        contact_person: '',
        mobile_number: '',
        email: '',
        address: '',
        city: '',
        state: '',
        pincode: ''
    });

    const handleSubmit = async (e) => {
        e.preventDefault();
        setSubmitting(true);
        try {
            const { error } = await supabase
                .from('pathshalas')
                .insert({
                    name: form.name,
                    sangh_name: form.sangh_name,
                    contact_person: form.contact_person,
                    mobile_number: form.mobile_number,
                    email: form.email,
                    address: form.address,
                    city: form.city,
                    state: form.state,
                    pincode: form.pincode
                });

            if (error) throw error;
            setSubmitted(true);
        } catch (err) {
            console.error("Error registering pathshala:", err);
            alert("Failed to submit registration. Please try again.");
        } finally {
            setSubmitting(false);
        }
    };

    if (submitted) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 font-sans">
                <div className="max-w-md w-full bg-white p-8 rounded-2xl shadow-xl border border-gray-100 text-center animate-in fade-in zoom-in-95 duration-500">
                    <div className="mx-auto flex items-center justify-center h-20 w-20 rounded-full bg-green-100 mb-6">
                        <CheckCircle className="h-10 w-10 text-green-600" />
                    </div>
                    <h2 className="text-3xl font-bold text-gray-900 mb-2 font-serif">Registration Submitted!</h2>
                    <p className="text-gray-600 mb-6 leading-relaxed">
                        Your Pathshala <span className="font-semibold text-gray-900">{form.name}</span> has been successfully registered. The library team will contact you shortly.
                    </p>
                    <div className="space-y-3">
                        <button
                            onClick={() => navigate('/library')}
                            className="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-md text-sm font-semibold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all"
                        >
                            Go to Library Dashboard
                        </button>
                        <button
                            onClick={() => setSubmitted(false)}
                            className="w-full flex justify-center py-3 px-4 border border-gray-300 rounded-lg text-sm font-semibold text-gray-700 bg-white hover:bg-gray-50 focus:outline-none transition-all"
                        >
                            Register Another Pathshala
                        </button>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 py-8 sm:py-12 px-4 sm:px-6 lg:px-8 font-sans">
            <div className="max-w-3xl mx-auto">
                <button
                    onClick={() => navigate(-1)}
                    className="flex items-center text-gray-500 hover:text-gray-900 mb-6 font-medium transition-colors group"
                >
                    <ArrowLeft className="h-5 w-5 mr-1 group-hover:-translate-x-1 transition-transform" /> Back
                </button>

                <div className="bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden animate-in fade-in slide-in-from-bottom-8 duration-500">
                    {/* Header */}
                    <div className="bg-gradient-to-r from-[#5c1212] to-[#ae2b2b] p-6 sm:p-8 text-white relative overflow-hidden">
                        <div className="absolute top-0 right-0 -mr-8 -mt-8 opacity-10 pointer-events-none">
                            <BookOpen size={180} />
                        </div>
                        <div className="relative z-10">
                            <span className="uppercase tracking-widest text-xs font-bold text-white/80 bg-black/20 px-3 py-1 rounded inline-block mb-3">
                                Library Portal
                            </span>
                            <h1 className="text-3xl sm:text-4xl font-bold font-serif leading-tight">
                                Pathshala Registration Module
                            </h1>
                            <p className="text-white/90 text-sm sm:text-base mt-2 font-light">
                                Register your Pathshala to access and maintain book details and sets.
                            </p>
                        </div>
                    </div>

                    <div className="p-6 sm:p-10">
                        <form onSubmit={handleSubmit} className="space-y-6">
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                {/* Pathshala Name */}
                                <div className="space-y-1 md:col-span-2">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        Pathshala Name <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <div className="relative">
                                        <Building className="absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 text-gray-400" />
                                        <input
                                            type="text"
                                            required
                                            placeholder="Enter Pathshala name"
                                            value={form.name}
                                            onChange={e => setForm({ ...form, name: e.target.value })}
                                            className="w-full rounded-xl border border-gray-200 pl-11 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                        />
                                    </div>
                                </div>

                                {/* Sangh Name */}
                                <div className="space-y-1 md:col-span-2">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        Sangh Name <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <div className="relative">
                                        <ShieldCheck className="absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 text-gray-400" />
                                        <input
                                            type="text"
                                            required
                                            placeholder="Enter Sangh name"
                                            value={form.sangh_name}
                                            onChange={e => setForm({ ...form, sangh_name: e.target.value })}
                                            className="w-full rounded-xl border border-gray-200 pl-11 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                        />
                                    </div>
                                </div>

                                {/* Contact Person */}
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        Contact Person <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <div className="relative">
                                        <User className="absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 text-gray-400" />
                                        <input
                                            type="text"
                                            required
                                            placeholder="Coordinator/Trustee Name"
                                            value={form.contact_person}
                                            onChange={e => setForm({ ...form, contact_person: e.target.value })}
                                            className="w-full rounded-xl border border-gray-200 pl-11 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                        />
                                    </div>
                                </div>

                                {/* Mobile Number */}
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        Mobile Number <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <div className="relative">
                                        <Phone className="absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 text-gray-400" />
                                        <input
                                            type="tel"
                                            required
                                            placeholder="Contact number"
                                            value={form.mobile_number}
                                            onChange={e => setForm({ ...form, mobile_number: e.target.value })}
                                            className="w-full rounded-xl border border-gray-200 pl-11 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                        />
                                    </div>
                                </div>

                                {/* Email ID */}
                                <div className="space-y-1 md:col-span-2">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        Email ID <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <div className="relative">
                                        <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4.5 w-4.5 text-gray-400" />
                                        <input
                                            type="email"
                                            required
                                            placeholder="you@example.com"
                                            value={form.email}
                                            onChange={e => setForm({ ...form, email: e.target.value })}
                                            className="w-full rounded-xl border border-gray-200 pl-11 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                        />
                                    </div>
                                </div>

                                {/* Address */}
                                <div className="space-y-1 md:col-span-2">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        Complete Address <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <div className="relative">
                                        <MapPin className="absolute left-4 top-4 h-4.5 w-4.5 text-gray-400" />
                                        <textarea
                                            required
                                            rows="3"
                                            placeholder="Street, area, landmarks"
                                            value={form.address}
                                            onChange={e => setForm({ ...form, address: e.target.value })}
                                            className="w-full rounded-xl border border-gray-200 pl-11 pr-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium resize-none"
                                        ></textarea>
                                    </div>
                                </div>

                                {/* City */}
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        City <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <input
                                        type="text"
                                        required
                                        placeholder="City Name"
                                        value={form.city}
                                        onChange={e => setForm({ ...form, city: e.target.value })}
                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                    />
                                </div>

                                {/* State */}
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        State <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <input
                                        type="text"
                                        required
                                        placeholder="State Name"
                                        value={form.state}
                                        onChange={e => setForm({ ...form, state: e.target.value })}
                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                    />
                                </div>

                                {/* Pincode */}
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-gray-700 uppercase tracking-wider block">
                                        Pincode <span className="text-[#ae2b2b]">*</span>
                                    </label>
                                    <input
                                        type="text"
                                        required
                                        maxLength="6"
                                        placeholder="Postal Code"
                                        value={form.pincode}
                                        onChange={e => setForm({ ...form, pincode: e.target.value.replace(/\D/g, '') })}
                                        className="w-full rounded-xl border border-gray-200 px-4 py-3 bg-gray-50/50 text-gray-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b] transition-all placeholder:text-gray-400 font-medium"
                                    />
                                </div>
                            </div>

                            <div className="pt-4">
                                <button
                                    type="submit"
                                    disabled={submitting}
                                    className="w-full flex justify-center py-4 px-4 border border-transparent rounded-xl shadow-lg text-base font-bold text-white bg-[#ae2b2b] hover:bg-[#8f1f1f] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[#ae2b2b] transition-all disabled:opacity-50"
                                >
                                    {submitting ? "Submitting Registration..." : "Register Pathshala"}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    );
}
