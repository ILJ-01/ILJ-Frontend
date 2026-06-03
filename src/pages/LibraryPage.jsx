import React, { useState, useEffect, useRef } from 'react';
import { supabase } from '../lib/supabase';
import * as XLSX from 'xlsx';
import {
    BookOpen,
    Building,
    Calendar,
    Plus,
    Search,
    Printer,
    FileSpreadsheet,
    Clock,
    Trash2,
    AlertTriangle,
    ArrowUpDown,
    Check,
    User,
    Phone,
    Mail,
    MapPin
} from 'lucide-react';
import { Button } from '../components/ui/button';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from '../components/ui/card';

export default function LibraryPage() {
    const [activeTab, setActiveTab] = useState('dashboard');

    // Core Data States
    const [pathshalas, setPathshalas] = useState([]);
    const [books, setBooks] = useState([]);
    const [assignments, setAssignments] = useState([]);
    const [loading, setLoading] = useState(true);

    // Form States
    const [newBook, setNewBook] = useState({
        book_no: '',
        book_name: '',
        author: '',
        publisher: '',
        language: '',
        set_no: ''
    });
    const [newAssignment, setNewAssignment] = useState({
        pathshala_id: '',
        set_no: '',
        date_of_issue: new Date().toISOString().split('T')[0],
        date_of_renewal: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0] // default 1 year
    });

    // Search and Filter States
    const [searchQuery, setSearchQuery] = useState('');
    const [filterPathshala, setFilterPathshala] = useState('all');
    const [filterSet, setFilterSet] = useState('all');
    const [filterRenewal, setFilterRenewal] = useState(false); // Sort by renewal date ascending

    // UI States
    const [showAddBook, setShowAddBook] = useState(false);
    const [showAddAssign, setShowAddAssign] = useState(false);
    const fileInputRef = useRef(null);

    useEffect(() => {
        loadAllData();
    }, []);

    const loadAllData = async () => {
        setLoading(true);
        try {
            // 1. Fetch Pathshalas
            const { data: pData, error: pErr } = await supabase
                .from('pathshalas')
                .select('*')
                .order('name');
            if (pErr) throw pErr;
            setPathshalas(pData || []);

            // 2. Fetch Books
            const { data: bData, error: bErr } = await supabase
                .from('library_books')
                .select('*')
                .order('book_no');
            if (bErr) throw bErr;
            setBooks(bData || []);

            // 3. Fetch Assignments
            const { data: aData, error: aErr } = await supabase
                .from('pathshala_assignments')
                .select(`
                    *,
                    pathshala:pathshala_id (
                        id,
                        name,
                        address,
                        city,
                        state,
                        pincode
                    )
                `)
                .order('date_of_renewal');
            if (aErr) throw aErr;
            setAssignments(aData || []);

        } catch (err) {
            console.error("Error loading library data:", err);
        } finally {
            setLoading(false);
        }
    };

    // --- Book Operations ---
    const handleAddBook = async (e) => {
        e.preventDefault();
        if (!newBook.book_no || !newBook.book_name) return;

        try {
            const { error } = await supabase
                .from('library_books')
                .insert([newBook]);

            if (error) throw error;

            alert("Book added successfully!");
            setNewBook({ book_no: '', book_name: '', author: '', publisher: '', language: '', set_no: '' });
            setShowAddBook(false);
            loadAllData();
        } catch (err) {
            console.error("Error adding book:", err);
            alert("Failed to add book. Ensure Book No. is unique.");
        }
    };

    const handleDeleteBook = async (id) => {
        if (!window.confirm("Are you sure you want to delete this book?")) return;
        try {
            const { error } = await supabase
                .from('library_books')
                .delete()
                .eq('id', id);
            if (error) throw error;
            loadAllData();
        } catch (err) {
            console.error("Error deleting book:", err);
        }
    };

    // --- Assignment Operations ---
    const handleAddAssignment = async (e) => {
        e.preventDefault();
        if (!newAssignment.pathshala_id || !newAssignment.set_no || !newAssignment.date_of_issue || !newAssignment.date_of_renewal) {
            alert("Please fill all required assignment fields.");
            return;
        }

        try {
            const { error } = await supabase
                .from('pathshala_assignments')
                .insert([newAssignment]);

            if (error) throw error;

            alert("Set assigned successfully!");
            setNewAssignment({
                pathshala_id: '',
                set_no: '',
                date_of_issue: new Date().toISOString().split('T')[0],
                date_of_renewal: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
            });
            setShowAddAssign(false);
            loadAllData();
        } catch (err) {
            console.error("Error assigning set:", err);
            alert("Failed to assign set. Please try again.");
        }
    };

    const handleDeleteAssignment = async (id) => {
        if (!window.confirm("Are you sure you want to remove this assignment?")) return;
        try {
            const { error } = await supabase
                .from('pathshala_assignments')
                .delete()
                .eq('id', id);
            if (error) throw error;
            loadAllData();
        } catch (err) {
            console.error("Error deleting assignment:", err);
        }
    };

    // --- Excel Functions ---
    const exportBooksToExcel = () => {
        const dataToExport = books.map(b => ({
            "Book No.": b.book_no,
            "Book Name": b.book_name,
            "Author": b.author || "",
            "Publisher": b.publisher || "",
            "Language": b.language || "",
            "Set No.": b.set_no || ""
        }));

        const ws = XLSX.utils.json_to_sheet(dataToExport);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Books");
        XLSX.writeFile(wb, `Books_Inventory_${new Date().toISOString().split('T')[0]}.xlsx`);
    };

    const handleImportExcel = (e) => {
        const file = e.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = async (evt) => {
            try {
                const data = evt.target.result;
                const workbook = XLSX.read(data, { type: 'binary' });
                const sheetName = workbook.SheetNames[0];
                const sheet = workbook.Sheets[sheetName];
                const json = XLSX.utils.sheet_to_json(sheet);

                const booksToInsert = json.map(row => ({
                    book_no: String(row["Book No."] || row["book_no"] || row["Book No"] || "").trim(),
                    book_name: String(row["Book Name"] || row["book_name"] || row["BookName"] || "").trim(),
                    author: String(row["Author"] || row["author"] || "").trim(),
                    publisher: String(row["Publisher"] || row["publisher"] || "").trim(),
                    language: String(row["Language"] || row["language"] || "").trim(),
                    set_no: String(row["Set No."] || row["set_no"] || row["SetNo"] || "").trim()
                })).filter(b => b.book_no && b.book_name);

                if (booksToInsert.length === 0) {
                    alert("No valid book entries found. Make sure columns match: 'Book No.' and 'Book Name'.");
                    return;
                }

                const { error } = await supabase
                    .from('library_books')
                    .upsert(booksToInsert, { onConflict: 'book_no' });

                if (error) throw error;
                alert(`Successfully imported ${booksToInsert.length} books!`);
                loadAllData();
            } catch (err) {
                console.error("Excel import error:", err);
                alert("Failed to import Excel data. Verify columns and check for unique Book Numbers.");
            }
        };
        reader.readAsBinaryString(file);
        // Clear input value so file can be re-uploaded
        if (fileInputRef.current) fileInputRef.current.value = "";
    };

    // --- Filter and Search Logic ---
    const getFilteredBooks = () => {
        return books.filter(b => {
            const matchesSearch =
                b.book_name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                b.book_no.toLowerCase().includes(searchQuery.toLowerCase()) ||
                (b.author && b.author.toLowerCase().includes(searchQuery.toLowerCase()));
            const matchesSet = filterSet === 'all' || b.set_no === filterSet;
            return matchesSearch && matchesSet;
        });
    };

    const getFilteredAssignments = () => {
        let list = [...assignments];

        // Search Query (by Pathshala name or set no)
        if (searchQuery) {
            list = list.filter(a =>
                (a.pathshala?.name && a.pathshala.name.toLowerCase().includes(searchQuery.toLowerCase())) ||
                a.set_no.toLowerCase().includes(searchQuery.toLowerCase())
            );
        }

        // Filter by Pathshala
        if (filterPathshala !== 'all') {
            list = list.filter(a => a.pathshala_id === filterPathshala);
        }

        // Filter by Set No.
        if (filterSet !== 'all') {
            list = list.filter(a => a.set_no === filterSet);
        }

        // Sort by Renewal Date
        if (filterRenewal) {
            list.sort((a, b) => new Date(a.date_of_renewal) - new Date(b.date_of_renewal));
        }

        return list;
    };

    // --- Renewal Notifications / Reminders ---
    const getUpcomingRenewals = () => {
        const today = new Date();
        const oneMonthFromNow = new Date();
        oneMonthFromNow.setMonth(today.getMonth() + 1);

        return assignments.filter(a => {
            const renewalDate = new Date(a.date_of_renewal);
            // Show renewals that are due in the next 1 month (or already overdue)
            return renewalDate <= oneMonthFromNow;
        }).sort((a, b) => new Date(a.date_of_renewal) - new Date(b.date_of_renewal));
    };

    // --- Print Functions ---
    const handlePrint = (sectionId, title) => {
        const style = document.createElement('style');
        style.type = 'text/css';
        style.id = 'temporary-print-style';
        style.innerHTML = `
            @media print {
                body * {
                    visibility: hidden !important;
                }
                #${sectionId}, #${sectionId} * {
                    visibility: visible !important;
                }
                #${sectionId} {
                    position: absolute !important;
                    left: 0 !important;
                    top: 0 !important;
                    width: 100% !important;
                    display: block !important;
                }
                .print-only {
                    display: flex !important;
                }
                .no-print, .no-print * {
                    display: none !important;
                    visibility: hidden !important;
                }
            }
        `;
        document.head.appendChild(style);
        window.print();

        const cleanup = () => {
            const el = document.getElementById('temporary-print-style');
            if (el) el.remove();
        };
        window.onafterprint = cleanup;
        setTimeout(cleanup, 2000);
    };

    // Quick Stats Calculation
    const totalPathshalasCount = pathshalas.length;
    const totalBooksCount = books.length;
    const totalAssignedSets = new Set(assignments.map(a => a.set_no)).size;
    const upcomingRenewalsCount = getUpcomingRenewals().length;
    const availableSets = [...new Set(books.map(b => b.set_no).filter(Boolean))].sort();

    return (
        <div className="min-h-screen bg-gray-50/50 pb-20 font-sans">

            {/* Banner Header */}
            <div className="bg-gradient-to-r from-[#5c1212] to-[#ae2b2b] p-6 sm:p-10 text-white relative overflow-hidden">
                <div className="absolute top-0 right-0 -mr-8 -mt-8 opacity-10 pointer-events-none">
                    <BookOpen size={180} />
                </div>
                <div className="relative z-10 max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                    <div>
                        <span className="uppercase tracking-widest text-xs font-bold text-white/80 bg-black/20 px-3 py-1 rounded inline-block mb-3">
                            Management Portal
                        </span>
                        <h1 className="text-3xl sm:text-4xl font-bold font-serif leading-tight">
                            Pathshala Library Module
                        </h1>
                        <p className="text-white/80 text-sm mt-1">
                            Register Pathshalas, manage inventory, and assign book sets.
                        </p>
                    </div>
                    <div className="flex gap-3">
                        <Button
                            onClick={() => window.open('/library-registration', '_blank')}
                            className="bg-amber-500 hover:bg-amber-600 text-white font-bold border-0 h-11 px-5 shadow-lg"
                        >
                            <Building className="mr-2 h-4 w-4" /> Register New Pathshala
                        </Button>
                    </div>
                </div>
            </div>

            {/* Stats Cards Section */}
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 -mt-6">
                <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
                    <div className="bg-white p-5 rounded-2xl shadow-md border border-gray-100 flex items-center gap-4 hover:scale-[1.02] transition-transform">
                        <div className="bg-red-50 p-3.5 rounded-xl text-[#ae2b2b]">
                            <Building className="h-6 w-6" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">Pathshalas</p>
                            <h3 className="text-2xl font-bold text-gray-900 mt-0.5">{totalPathshalasCount}</h3>
                        </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl shadow-md border border-gray-100 flex items-center gap-4 hover:scale-[1.02] transition-transform">
                        <div className="bg-amber-50 p-3.5 rounded-xl text-amber-600">
                            <BookOpen className="h-6 w-6" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">Total Books</p>
                            <h3 className="text-2xl font-bold text-gray-900 mt-0.5">{totalBooksCount}</h3>
                        </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl shadow-md border border-gray-100 flex items-center gap-4 hover:scale-[1.02] transition-transform">
                        <div className="bg-blue-50 p-3.5 rounded-xl text-blue-600">
                            <Calendar className="h-6 w-6" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">Unique Sets Active</p>
                            <h3 className="text-2xl font-bold text-gray-900 mt-0.5">{totalAssignedSets}</h3>
                        </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl shadow-md border border-gray-100 flex items-center gap-4 hover:scale-[1.02] transition-transform relative overflow-hidden">
                        <div className="absolute top-0 left-0 right-0 h-1 bg-amber-500"></div>
                        <div className="bg-amber-50 p-3.5 rounded-xl text-amber-700">
                            <Clock className="h-6 w-6" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide">Due Renewals</p>
                            <h3 className="text-2xl font-bold text-gray-900 mt-0.5 flex items-center gap-1.5">
                                {upcomingRenewalsCount}
                                {upcomingRenewalsCount > 0 && <span className="h-2 w-2 rounded-full bg-amber-500 animate-ping"></span>}
                            </h3>
                        </div>
                    </div>
                </div>
            </div>

            {/* Main Tabs Navigation */}
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-10">
                <div className="flex border-b border-gray-200 gap-1 overflow-x-auto pb-px">
                    {[
                        { id: 'dashboard', label: 'All Pathshalas', icon: Building },
                        { id: 'books', label: 'Book Entry Module', icon: BookOpen },
                        { id: 'assign', label: 'Assign Sets', icon: Calendar },
                        { id: 'renewals', label: 'Renewals & Reminders', icon: Clock }
                    ].map(tab => {
                        const Icon = tab.icon;
                        const isActive = activeTab === tab.id;
                        return (
                            <button
                                key={tab.id}
                                onClick={() => {
                                    setActiveTab(tab.id);
                                    setSearchQuery('');
                                    setFilterPathshala('all');
                                    setFilterSet('all');
                                    setFilterRenewal(false);
                                }}
                                className={`flex items-center gap-2 px-5 py-3 border-b-2 font-bold text-sm whitespace-nowrap transition-all select-none ${isActive
                                        ? 'border-[#ae2b2b] text-[#ae2b2b]'
                                        : 'border-transparent text-gray-500 hover:text-gray-900'
                                    }`}
                            >
                                <Icon className="h-4.5 w-4.5" />
                                {tab.label}
                            </button>
                        );
                    })}
                </div>

                {/* Dashboard Screen */}
                {activeTab === 'dashboard' && (
                    <div className="mt-8 space-y-6">
                        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-4 rounded-xl border border-gray-200">
                            <div className="relative flex-1 max-w-md w-full">
                                <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                <input
                                    type="text"
                                    placeholder="Search by Pathshala name or coordinator..."
                                    value={searchQuery}
                                    onChange={e => setSearchQuery(e.target.value)}
                                    className="w-full rounded-lg border border-gray-200 pl-10 pr-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b]"
                                />
                            </div>
                            <Button
                                onClick={() => handlePrint('print-pathshalas', 'Pathshalas Report')}
                                className="bg-transparent hover:bg-gray-100 text-gray-700 border border-gray-200 h-9 font-semibold text-xs py-2"
                            >
                                <Printer className="mr-2 h-4 w-4" /> Print Pathshalas Report
                            </Button>
                        </div>

                        {/* Printable Section for Pathshalas */}
                        <div id="print-pathshalas" className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                            <div className="p-6 border-b border-gray-100 flex justify-between items-center print-only hidden">
                                <div>
                                    <h2 className="text-xl font-bold text-gray-900 font-serif">I Love Jinshasan</h2>
                                    <p className="text-xs text-gray-500">Registered Pathshalas Report</p>
                                </div>
                                <span className="text-xs font-mono font-medium">{new Date().toLocaleDateString('en-IN')}</span>
                            </div>
                            <div className="overflow-x-auto">
                                <table className="w-full text-left border-collapse text-sm">
                                    <thead>
                                        <tr className="bg-gray-50/75 border-b border-gray-200 text-gray-600 font-bold">
                                            <th className="p-4">Pathshala Details</th>
                                            <th className="p-4">Sangh Details</th>
                                            <th className="p-4">Contact Person</th>
                                            <th className="p-4">Location</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100">
                                        {pathshalas
                                            .filter(p =>
                                                p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                                                p.contact_person.toLowerCase().includes(searchQuery.toLowerCase()) ||
                                                p.sangh_name.toLowerCase().includes(searchQuery.toLowerCase())
                                            )
                                            .map(p => (
                                                <tr key={p.id} className="hover:bg-gray-50/50 transition-colors">
                                                    <td className="p-4">
                                                        <div className="font-bold text-gray-900 text-base">{p.name}</div>
                                                        <div className="text-xs font-mono text-gray-400 mt-0.5">ID: {p.id.substring(0, 8)}</div>
                                                    </td>
                                                    <td className="p-4">
                                                        <span className="font-semibold text-gray-800 bg-gray-100 px-2.5 py-0.5 rounded-full text-xs">{p.sangh_name}</span>
                                                    </td>
                                                    <td className="p-4 space-y-1">
                                                        <div className="font-medium text-gray-900 flex items-center gap-1.5">
                                                            <User className="h-3.5 w-3.5 text-gray-400" /> {p.contact_person}
                                                        </div>
                                                        <div className="text-xs text-gray-600 flex items-center gap-1.5">
                                                            <Phone className="h-3.5 w-3.5 text-gray-400" /> {p.mobile_number}
                                                        </div>
                                                        <div className="text-xs text-gray-600 flex items-center gap-1.5">
                                                            <Mail className="h-3.5 w-3.5 text-gray-400" /> {p.email}
                                                        </div>
                                                    </td>
                                                    <td className="p-4 space-y-1">
                                                        <div className="text-gray-800 flex items-start gap-1.5">
                                                            <MapPin className="h-4 w-4 text-gray-400 shrink-0 mt-0.5" />
                                                            <span className="text-xs max-w-xs">{p.address}</span>
                                                        </div>
                                                        <div className="text-xs font-bold text-gray-500 pl-5">{p.city}, {p.state} - {p.pincode}</div>
                                                    </td>
                                                </tr>
                                            ))}
                                        {pathshalas.length === 0 && (
                                            <tr>
                                                <td colSpan="4" className="text-center py-10 text-gray-500">No registered Pathshalas found.</td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                )}

                {/* Book Entry Module Screen */}
                {activeTab === 'books' && (
                    <div className="mt-8 space-y-6">
                        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-4 rounded-xl border border-gray-200">

                            {/* Search and Filters */}
                            <div className="flex flex-wrap items-center gap-3 flex-1 w-full">
                                <div className="relative max-w-xs w-full">
                                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                                    <input
                                        type="text"
                                        placeholder="Search by book name, no..."
                                        value={searchQuery}
                                        onChange={e => setSearchQuery(e.target.value)}
                                        className="w-full rounded-lg border border-gray-200 pl-9 pr-4 py-2 text-xs focus:outline-none focus:ring-2 focus:ring-[#ae2b2b]/20 focus:border-[#ae2b2b]"
                                    />
                                </div>
                                <select
                                    value={filterSet}
                                    onChange={e => setFilterSet(e.target.value)}
                                    className="rounded-lg border border-gray-200 px-3 py-2 text-xs focus:outline-none"
                                >
                                    <option value="all">All Set Numbers</option>
                                    {[...new Set(books.map(b => b.set_no).filter(Boolean))].sort().map(set => (
                                        <option key={set} value={set}>Set No. {set}</option>
                                    ))}
                                </select>
                            </div>

                            {/* Actions Panel */}
                            <div className="flex flex-wrap gap-2.5 w-full sm:w-auto">
                                <Button
                                    onClick={() => handlePrint('print-books', 'Books Report')}
                                    className="bg-transparent hover:bg-gray-100 text-gray-700 border border-gray-200 h-9 font-semibold text-xs"
                                    title="Print report"
                                >
                                    <Printer className="h-4 w-4" />
                                </Button>

                                <Button
                                    onClick={exportBooksToExcel}
                                    className="bg-emerald-600 hover:bg-emerald-700 text-white font-bold h-9 text-xs"
                                >
                                    <FileSpreadsheet className="mr-1.5 h-4 w-4" /> Export Excel
                                </Button>

                                <label className="inline-flex items-center justify-center bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs px-4 h-9 rounded-lg cursor-pointer transition-colors shadow">
                                    <FileSpreadsheet className="mr-1.5 h-4 w-4" /> Import Excel
                                    <input
                                        type="file"
                                        ref={fileInputRef}
                                        accept=".xlsx, .xls"
                                        onChange={handleImportExcel}
                                        className="hidden"
                                    />
                                </label>

                                <Button
                                    onClick={() => setShowAddBook(true)}
                                    className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-bold h-9 text-xs"
                                >
                                    <Plus className="mr-1.5 h-4 w-4" /> Add Book
                                </Button>
                            </div>
                        </div>

                        {/* Add Book Dialog Overlay */}
                        {showAddBook && (
                            <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm">
                                <div className="bg-white rounded-2xl w-full max-w-md p-6 shadow-2xl relative">
                                    <h3 className="text-xl font-bold text-gray-900 font-serif mb-4 pb-2 border-b">Add New Book</h3>
                                    <form onSubmit={handleAddBook} className="space-y-4">
                                        <div className="grid grid-cols-2 gap-4">
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase">Book No. *</label>
                                                <input
                                                    type="text" required placeholder="A101"
                                                    value={newBook.book_no} onChange={e => setNewBook({ ...newBook, book_no: e.target.value.toUpperCase() })}
                                                    className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                                />
                                            </div>
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase">Set No.</label>
                                                <input
                                                    type="text" placeholder="1"
                                                    value={newBook.set_no} onChange={e => setNewBook({ ...newBook, set_no: e.target.value })}
                                                    className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                                />
                                            </div>
                                        </div>
                                        <div>
                                            <label className="text-xs font-bold text-gray-500 uppercase">Book Name *</label>
                                            <input
                                                type="text" required placeholder="e.g. Navkar Mantra Mahima"
                                                value={newBook.book_name} onChange={e => setNewBook({ ...newBook, book_name: e.target.value })}
                                                className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                            />
                                        </div>
                                        <div>
                                            <label className="text-xs font-bold text-gray-500 uppercase">Author</label>
                                            <input
                                                type="text" placeholder="Author name"
                                                value={newBook.author} onChange={e => setNewBook({ ...newBook, author: e.target.value })}
                                                className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                            />
                                        </div>
                                        <div className="grid grid-cols-2 gap-4">
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase">Publisher</label>
                                                <input
                                                    type="text" placeholder="Publisher"
                                                    value={newBook.publisher} onChange={e => setNewBook({ ...newBook, publisher: e.target.value })}
                                                    className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                                />
                                            </div>
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase">Language</label>
                                                <input
                                                    type="text" placeholder="Gujarati / Hindi / English"
                                                    value={newBook.language} onChange={e => setNewBook({ ...newBook, language: e.target.value })}
                                                    className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                                />
                                            </div>
                                        </div>
                                        <div className="flex gap-3 justify-end pt-4 border-t">
                                            <Button type="button" variant="outline" onClick={() => setShowAddBook(false)} className="h-9">Cancel</Button>
                                            <Button type="submit" className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white h-9 font-bold px-6">Save Book</Button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        )}

                        {/* Printable Book inventory section */}
                        <div id="print-books" className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                            <div className="p-6 border-b border-gray-100 flex justify-between items-center print-only hidden">
                                <div>
                                    <h2 className="text-xl font-bold text-gray-900 font-serif">I Love Jinshasan</h2>
                                    <p className="text-xs text-gray-500">Books Inventory Report</p>
                                </div>
                                <span className="text-xs font-mono font-medium">{new Date().toLocaleDateString('en-IN')}</span>
                            </div>
                            <div className="overflow-x-auto">
                                <table className="w-full text-left border-collapse text-sm">
                                    <thead>
                                        <tr className="bg-gray-50/75 border-b border-gray-200 text-gray-600 font-bold">
                                            <th className="p-4">Book No.</th>
                                            <th className="p-4">Book Name</th>
                                            <th className="p-4">Author</th>
                                            <th className="p-4">Publisher</th>
                                            <th className="p-4">Language</th>
                                            <th className="p-4">Set No.</th>
                                            <th className="p-4 text-right no-print">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100">
                                        {getFilteredBooks().map((b) => (
                                            <tr key={b.id} className="hover:bg-gray-50/50 transition-colors">
                                                <td className="p-4 font-mono font-bold text-gray-900">{b.book_no}</td>
                                                <td className="p-4 font-medium text-gray-800">{b.book_name}</td>
                                                <td className="p-4 text-gray-600">{b.author || '-'}</td>
                                                <td className="p-4 text-gray-500 text-xs">{b.publisher || '-'}</td>
                                                <td className="p-4 text-gray-500 text-xs">{b.language || '-'}</td>
                                                <td className="p-4">
                                                    {b.set_no ? (
                                                        <span className="bg-amber-50 border border-amber-200 text-amber-800 text-xs px-2 py-0.5 rounded font-bold">Set {b.set_no}</span>
                                                    ) : (
                                                        <span className="text-gray-400 text-xs italic">Unassigned</span>
                                                    )}
                                                </td>
                                                <td className="p-4 text-right no-print">
                                                    <button
                                                        onClick={() => handleDeleteBook(b.id)}
                                                        className="text-red-500 hover:text-red-700 hover:bg-red-50 p-1.5 rounded transition-colors"
                                                        title="Delete Book"
                                                    >
                                                        <Trash2 className="h-4 w-4" />
                                                    </button>
                                                </td>
                                            </tr>
                                        ))}
                                        {getFilteredBooks().length === 0 && (
                                            <tr>
                                                <td colSpan="7" className="text-center py-10 text-gray-500">No books found in inventory.</td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                )}

                {/* Assign Set to Pathshala Screen */}
                {activeTab === 'assign' && (
                    <div className="mt-8 space-y-6">
                        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white p-4 rounded-xl border border-gray-200">

                            {/* Filters */}
                            <div className="flex flex-wrap items-center gap-3 flex-1 w-full">
                                <select
                                    value={filterPathshala}
                                    onChange={e => setFilterPathshala(e.target.value)}
                                    className="rounded-lg border border-gray-200 px-3 py-2 text-xs focus:outline-none"
                                >
                                    <option value="all">All Pathshalas</option>
                                    {pathshalas.map(p => (
                                        <option key={p.id} value={p.id}>{p.name}</option>
                                    ))}
                                </select>

                                <select
                                    value={filterSet}
                                    onChange={e => setFilterSet(e.target.value)}
                                    className="rounded-lg border border-gray-200 px-3 py-2 text-xs focus:outline-none"
                                >
                                    <option value="all">All Sets</option>
                                    {[...new Set(assignments.map(a => a.set_no))].sort().map(set => (
                                        <option key={set} value={set}>Set {set}</option>
                                    ))}
                                </select>

                                <button
                                    onClick={() => setFilterRenewal(!filterRenewal)}
                                    className={`inline-flex items-center gap-1.5 px-3 py-2 rounded-lg border text-xs font-bold transition-all ${filterRenewal
                                            ? 'bg-amber-50 border-amber-200 text-amber-800'
                                            : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'
                                        }`}
                                >
                                    <ArrowUpDown className="h-3.5 w-3.5" /> Renewal Date Ascending
                                </button>
                            </div>

                            {/* Actions */}
                            <div className="flex gap-2">
                                <Button
                                    onClick={() => handlePrint('print-assignments', 'Assigned Sets Report')}
                                    className="bg-transparent hover:bg-gray-100 text-gray-700 border border-gray-200 h-9 font-semibold text-xs"
                                >
                                    <Printer className="mr-1.5 h-4 w-4" /> Print Report
                                </Button>
                                <Button
                                    onClick={() => setShowAddAssign(true)}
                                    className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white font-bold h-9 text-xs"
                                >
                                    <Plus className="mr-1.5 h-4 w-4" /> Assign New Set
                                </Button>
                            </div>
                        </div>

                        {/* Assign Set Modal */}
                        {showAddAssign && (
                            <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/60 p-4 backdrop-blur-sm">
                                <div className="bg-white rounded-2xl w-full max-w-md p-6 shadow-2xl relative">
                                    <h3 className="text-xl font-bold text-gray-900 font-serif mb-4 pb-2 border-b">Assign Set to Pathshala</h3>
                                    <form onSubmit={handleAddAssignment} className="space-y-4">

                                        {/* Select Pathshala (Auto-fetched) */}
                                        <div>
                                            <label className="text-xs font-bold text-gray-500 uppercase">Pathshala Name *</label>
                                            <select
                                                required
                                                value={newAssignment.pathshala_id}
                                                onChange={e => setNewAssignment({ ...newAssignment, pathshala_id: e.target.value })}
                                                className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1 bg-white"
                                            >
                                                <option value="">Select Pathshala</option>
                                                {pathshalas.map(p => (
                                                    <option key={p.id} value={p.id}>{p.name}</option>
                                                ))}
                                            </select>
                                        </div>

                                        {/* Address (Read-only representation) */}
                                        {newAssignment.pathshala_id && (
                                            <div className="bg-gray-50 p-3 rounded-lg border text-xs text-gray-600">
                                                <strong>Address:</strong>{" "}
                                                {(() => {
                                                    const match = pathshalas.find(p => p.id === newAssignment.pathshala_id);
                                                    return match ? `${match.address}, ${match.city}, ${match.state} - ${match.pincode}` : "N/A";
                                                })()}
                                            </div>
                                        )}

                                        <div className="grid grid-cols-2 gap-4">
                                            {/* Set Number */}
                                            <div className="col-span-2">
                                                <label className="text-xs font-bold text-gray-500 uppercase">Set Number *</label>
                                                <select
                                                    required
                                                    value={newAssignment.set_no}
                                                    onChange={e => setNewAssignment({ ...newAssignment, set_no: e.target.value })}
                                                    className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1 bg-white text-gray-950"
                                                >
                                                    <option value="">Select Set</option>
                                                    {availableSets.map(set => (
                                                        <option key={set} value={set}>Set {set}</option>
                                                    ))}
                                                </select>
                                                {availableSets.length === 0 && (
                                                    <p className="text-[10px] text-red-500 mt-1">No sets available. Create book entries with Set Numbers first.</p>
                                                )}
                                            </div>

                                            {/* Date of Issue */}
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase">Date of Issue *</label>
                                                <input
                                                    type="date" required
                                                    value={newAssignment.date_of_issue} onChange={e => setNewAssignment({ ...newAssignment, date_of_issue: e.target.value })}
                                                    className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                                />
                                            </div>

                                            {/* Date of Renewal */}
                                            <div>
                                                <label className="text-xs font-bold text-gray-500 uppercase">Date of Renewal *</label>
                                                <input
                                                    type="date" required
                                                    value={newAssignment.date_of_renewal} onChange={e => setNewAssignment({ ...newAssignment, date_of_renewal: e.target.value })}
                                                    className="w-full p-2.5 border rounded-lg focus:ring-2 focus:ring-[#ae2b2b]/20 outline-none text-sm mt-1"
                                                />
                                            </div>
                                        </div>

                                        <div className="flex gap-3 justify-end pt-4 border-t">
                                            <Button type="button" variant="outline" onClick={() => setShowAddAssign(false)} className="h-9">Cancel</Button>
                                            <Button type="submit" className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white h-9 font-bold px-6">Assign Set</Button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        )}

                        {/* Printable Assignments Section */}
                        <div id="print-assignments" className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                            <div className="p-6 border-b border-gray-100 flex justify-between items-center print-only hidden">
                                <div>
                                    <h2 className="text-xl font-bold text-gray-900 font-serif">I Love Jinshasan</h2>
                                    <p className="text-xs text-gray-500">Pathshala Book Set Assignments</p>
                                </div>
                                <span className="text-xs font-mono font-medium">{new Date().toLocaleDateString('en-IN')}</span>
                            </div>
                            <div className="overflow-x-auto">
                                <table className="w-full text-left border-collapse text-sm">
                                    <thead>
                                        <tr className="bg-gray-50/75 border-b border-gray-200 text-gray-600 font-bold">
                                            <th className="p-4">Pathshala Name</th>
                                            <th className="p-4">Address</th>
                                            <th className="p-4">Set No.</th>
                                            <th className="p-4">Date of Issue</th>
                                            <th className="p-4">Date of Renewal</th>
                                            <th className="p-4 text-right no-print">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100">
                                        {getFilteredAssignments().map((a) => (
                                            <tr key={a.id} className="hover:bg-gray-50/50 transition-colors">
                                                <td className="p-4 font-bold text-gray-900">{a.pathshala?.name || 'Unknown'}</td>
                                                <td className="p-4 text-xs text-gray-600">
                                                    {a.pathshala ? `${a.pathshala.address}, ${a.pathshala.city}, ${a.pathshala.state} - ${a.pathshala.pincode}` : '-'}
                                                </td>
                                                <td className="p-4 font-semibold text-amber-800">Set {a.set_no}</td>
                                                <td className="p-4 font-mono text-gray-500">
                                                    {new Date(a.date_of_issue).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })}
                                                </td>
                                                <td className="p-4 font-mono text-gray-900 font-medium">
                                                    {new Date(a.date_of_renewal).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })}
                                                </td>
                                                <td className="p-4 text-right no-print">
                                                    <button
                                                        onClick={() => handleDeleteAssignment(a.id)}
                                                        className="text-red-500 hover:text-red-700 hover:bg-red-50 p-1.5 rounded transition-colors"
                                                        title="Remove Assignment"
                                                    >
                                                        <Trash2 className="h-4 w-4" />
                                                    </button>
                                                </td>
                                            </tr>
                                        ))}
                                        {getFilteredAssignments().length === 0 && (
                                            <tr>
                                                <td colSpan="6" className="text-center py-10 text-gray-500">No book set assignments match current filters.</td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                )}

                {/* Renewals and Reminders Screen */}
                {activeTab === 'renewals' && (
                    <div className="mt-8 space-y-6 animate-in fade-in duration-300">

                        {/* Alert / Notification Bar for renewals due in 1 month */}
                        {getUpcomingRenewals().length > 0 ? (
                            <div className="bg-amber-50 border border-amber-200 rounded-xl p-4 flex items-start gap-3.5 shadow-sm text-sm">
                                <div className="bg-amber-100 p-2 rounded-lg text-amber-800 shrink-0">
                                    <AlertTriangle className="h-5 w-5" />
                                </div>
                                <div>
                                    <h4 className="font-bold text-amber-900 text-base">Renewal Reminders & Alerts</h4>
                                    <p className="text-amber-700 mt-0.5 leading-relaxed">
                                        The following Pathshalas have book sets due for renewal in the next <strong>30 days</strong>. Please prepare and dispatch renewal notifications to coordinators.
                                    </p>
                                </div>
                            </div>
                        ) : (
                            <div className="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center gap-3.5 text-sm text-green-700">
                                <Check className="h-5 w-5 text-green-600 bg-green-100 p-0.5 rounded-full shrink-0" />
                                <div>
                                    <span className="font-bold">All clear!</span> No set renewals due in the upcoming month.
                                </div>
                            </div>
                        )}

                        <div className="flex justify-between items-center bg-white p-4 rounded-xl border border-gray-200">
                            <span className="text-xs font-bold text-gray-500 uppercase tracking-wide">Sorted by Renewal Date (Ascending order)</span>
                            <Button
                                onClick={() => handlePrint('print-renewals', 'Upcoming Renewals Report')}
                                className="bg-transparent hover:bg-gray-100 text-gray-700 border border-gray-200 h-9 font-semibold text-xs"
                            >
                                <Printer className="mr-1.5 h-4 w-4" /> Print Renewal List
                            </Button>
                        </div>

                        {/* Printable Renewals section */}
                        <div id="print-renewals" className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                            <div className="p-6 border-b border-gray-100 flex justify-between items-center print-only hidden">
                                <div>
                                    <h2 className="text-xl font-bold text-gray-900 font-serif">I Love Jinshasan</h2>
                                    <p className="text-xs text-gray-500">Upcoming Book Set Renewals Report</p>
                                </div>
                                <span className="text-xs font-mono font-medium">{new Date().toLocaleDateString('en-IN')}</span>
                            </div>
                            <div className="overflow-x-auto">
                                <table className="w-full text-left border-collapse text-sm">
                                    <thead>
                                        <tr className="bg-gray-50/75 border-b border-gray-200 text-gray-600 font-bold">
                                            <th className="p-4">Pathshala</th>
                                            <th className="p-4">Set No.</th>
                                            <th className="p-4">Renewal Date</th>
                                            <th className="p-4">Contact Detail</th>
                                            <th className="p-4">Status</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-gray-100">
                                        {getUpcomingRenewals().map((a) => {
                                            const daysLeft = Math.ceil((new Date(a.date_of_renewal) - new Date()) / (1000 * 60 * 60 * 24));
                                            const isOverdue = daysLeft < 0;
                                            return (
                                                <tr key={a.id} className="hover:bg-gray-50/50 transition-colors">
                                                    <td className="p-4 font-bold text-gray-900">{a.pathshala?.name || 'Unknown'}</td>
                                                    <td className="p-4 font-semibold text-amber-800">Set {a.set_no}</td>
                                                    <td className="p-4 font-mono font-medium text-gray-800">
                                                        {new Date(a.date_of_renewal).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' })}
                                                    </td>
                                                    <td className="p-4">
                                                        {a.pathshala ? (
                                                            <div>
                                                                <div className="font-semibold text-gray-800 text-xs">{a.pathshala.contact_person}</div>
                                                                <div className="text-gray-500 text-xs mt-0.5">{a.pathshala.mobile_number}</div>
                                                            </div>
                                                        ) : '-'}
                                                    </td>
                                                    <td className="p-4">
                                                        {isOverdue ? (
                                                            <span className="bg-rose-50 border border-rose-200 text-rose-700 text-xs px-2.5 py-1 rounded font-bold">Overdue by {Math.abs(daysLeft)} Days</span>
                                                        ) : (
                                                            <span className="bg-amber-50 border border-amber-200 text-amber-700 text-xs px-2.5 py-1 rounded font-bold">Due in {daysLeft} Days</span>
                                                        )}
                                                    </td>
                                                </tr>
                                            );
                                        })}
                                        {getUpcomingRenewals().length === 0 && (
                                            <tr>
                                                <td colSpan="5" className="text-center py-10 text-gray-500">No upcoming renewals at this time.</td>
                                            </tr>
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                )}
            </div>

        </div>
    );
}
