import React, { useState, useMemo } from 'react';
import { Users, ChevronDown, ChevronUp, Phone, Mail } from 'lucide-react';

export default function AdminKalyanMitras({ volunteers }) {
    const [expandedMitra, setExpandedMitra] = useState(null);

    const kalyanMitras = useMemo(() => {
        const mitrasMap = {};

        // Group volunteers by kalyan_mitra
        volunteers.forEach(v => {
            if (v.kalyan_mitra) {
                const mitraName = v.kalyan_mitra.trim();
                if (!mitrasMap[mitraName]) {
                    mitrasMap[mitraName] = {
                        name: mitraName,
                        assignedVolunteers: []
                    };
                }
                mitrasMap[mitraName].assignedVolunteers.push(v);
            }
        });

        // Convert to array and sort by number of assigned volunteers (descending)
        return Object.values(mitrasMap).sort((a, b) => b.assignedVolunteers.length - a.assignedVolunteers.length);
    }, [volunteers]);

    if (kalyanMitras.length === 0) {
        return (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-8 text-center">
                <Users className="h-12 w-12 text-gray-300 mx-auto mb-4" />
                <h3 className="text-lg font-bold text-gray-900 mb-1">No Kalyan Mitras Found</h3>
                <p className="text-gray-500">There are currently no volunteers assigned to a Kalyan Mitra.</p>
            </div>
        );
    }

    return (
        <div className="space-y-6">
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                <div className="overflow-x-auto">
                    <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-gray-50">
                            <tr>
                                <th scope="col" className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Name of Kalyan Mitra
                                </th>
                                <th scope="col" className="px-6 py-4 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    No. of Volunteers Assigned
                                </th>
                                <th scope="col" className="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                            {kalyanMitras.map((mitra, idx) => {
                                const isExpanded = expandedMitra === mitra.name;
                                return (
                                    <React.Fragment key={idx}>
                                        <tr 
                                            className="hover:bg-gray-50 cursor-pointer transition-colors"
                                            onClick={() => setExpandedMitra(isExpanded ? null : mitra.name)}
                                        >
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <div className="flex items-center gap-3">
                                                    <div className="w-8 h-8 rounded-full bg-[#ae2b2b]/10 flex items-center justify-center text-[#ae2b2b] font-bold text-sm">
                                                        {mitra.name.charAt(0)}
                                                    </div>
                                                    <div className="text-sm font-medium text-gray-900">{mitra.name}</div>
                                                </div>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <span className="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                    {mitra.assignedVolunteers.length} Volunteers
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                <button className="text-gray-400 hover:text-gray-600 transition-colors">
                                                    {isExpanded ? <ChevronUp className="h-5 w-5" /> : <ChevronDown className="h-5 w-5" />}
                                                </button>
                                            </td>
                                        </tr>
                                        {isExpanded && (
                                            <tr>
                                                <td colSpan="3" className="px-0 py-0 bg-gray-50/50">
                                                    <div className="px-6 py-4 border-l-4 border-[#ae2b2b]">
                                                        <h4 className="text-xs font-bold text-gray-500 uppercase tracking-wider mb-3">Assigned Volunteers</h4>
                                                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                                            {mitra.assignedVolunteers.map(vol => (
                                                                <div key={vol.id} className="bg-white p-3 rounded-lg border border-gray-200 shadow-sm flex flex-col gap-2">
                                                                    <div className="font-medium text-sm text-gray-900">
                                                                        {vol.first_name} {vol.last_name}
                                                                        <span className="text-xs text-gray-500 ml-2 font-normal">({vol.ilj_id})</span>
                                                                    </div>
                                                                    <div className="flex flex-col gap-1 text-xs text-gray-600">
                                                                        {vol.mobile_number && (
                                                                            <div className="flex items-center gap-1.5">
                                                                                <Phone className="h-3 w-3" /> {vol.mobile_number}
                                                                            </div>
                                                                        )}
                                                                        {vol.email && (
                                                                            <div className="flex items-center gap-1.5">
                                                                                <Mail className="h-3 w-3" /> {vol.email}
                                                                            </div>
                                                                        )}
                                                                    </div>
                                                                </div>
                                                            ))}
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        )}
                                    </React.Fragment>
                                );
                            })}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}
