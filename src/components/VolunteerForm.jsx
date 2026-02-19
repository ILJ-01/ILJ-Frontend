import { useState, useEffect } from "react";
import { registerVolunteer, checkEmailExists } from "@/lib/supabase";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { format, differenceInYears } from "date-fns";
import { CalendarIcon, User, Phone, MapPin, GraduationCap, Briefcase, Heart, Link as LinkIcon, CheckSquare, Clock, HandHeart, Send, PlusCircle, Trash2, FileText, Mic, Palette, Camera, Calendar as LucideCalendar, Megaphone, School, Code, Users, Shield, Share2, Info } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Calendar } from "@/components/ui/calendar";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";

const formSchema = z.object({
    // 1. Personal Info
    firstName: z.string().min(2, "First name is required"),
    middleName: z.string().optional(),
    lastName: z.string().min(2, "Last name is required"),
    dob: z.date({
        required_error: "Date of birth is required",
        invalid_type_error: "Date of birth is required"
    }),
    gender: z.enum(["Male", "Female"], { required_error: "Please select your gender" }),

    // 2. Contact Info
    mobileNumber: z.string().min(10, "Mobile number must be at least 10 digits"),
    email: z.string().email("Invalid email address"),

    // 3. Address
    addressLine1: z.string().min(1, "Address Line 1 is required"),
    addressLine2: z.string().min(1, "Area/Locality is required"),
    district: z.string().min(1, "District is required"),
    city: z.string().min(1, "City is required"),
    state: z.string().min(1, "State is required"),
    country: z.string().min(1, "Country is required"),
    pincode: z.string().min(1, "Postal Code is required"),
    sanghName: z.string().optional(),

    // 4. Educational & Dharmik
    dharmikStudies: z.string().optional(),
    qualification: z.string().min(1, "Highest qualification is required"),
    specialization: z.string().min(1, "Field of study is required"),

    // 5. Professional Status
    occupation: z.enum(["Student", "Working Professional", "Freelancer / Self-Employed", "Homemaker", "Other"], { required_error: "Select your occupation status" }),
    occupationOther: z.string().optional(),

    // 6. Interests
    hobbies: z.string().optional(),
    skills: z.string().optional(),

    // 7. Referral
    referredBy: z.string().optional(),

    // 8. Areas of Volunteering
    volunteeringPreference1: z.string({ required_error: "Please select your 1st preference" }),
    volunteeringPreference2: z.string().optional(),
    volunteeringPreference3: z.string().optional(),

    // Additional Areas (Checkboxes)
    additionalAreas: z.array(z.string()).optional(),

    // 9. Availability
    availabilityDays: z.enum(["Weekdays", "Weekends", "Flexible"], { required_error: "Availability is required" }),
    timeCommitment: z.string().optional(),

    // 10. Participation Mode
    participationMode: z.enum(["Voluntary (Seva-based)", "Paid Basis (Project or Role-based)", "Flexible / Open to Discussion"], { required_error: "Please select a mode" }),

    // 11. Pathshala Specific
    pathshalaRole: z.string().optional(),
});

const volunteeringOptions = [
    { label: "Research & Documentation", icon: FileText },
    { label: "Content Writing (Articles, Blogs, Scripts)", icon: FileText },
    { label: "Public Speaking, Acting & Stage Activities", icon: Mic },
    { label: "Graphic Design & Video Editing", icon: Palette },
    { label: "Photography & Videography", icon: Camera },
    { label: "Event Planning & Management", icon: LucideCalendar },
    { label: "Marketing & Outreach", icon: Megaphone },
    { label: "Marketing & Outreach", icon: Megaphone },
    { label: "Inhouse Pathshala and Home Schooling", icon: School },
    { label: "IT & Technical Support", icon: Code },
];

// Special additional options as checkboxes
const additionalOptions = [
    { label: "Building Community & Government Relations", icon: Users },
    { label: "Defending Jainism On-field engagement", icon: Shield },
    { label: "Defending Jainism on Social media & digital platforms", icon: Share2 }
];

export default function VolunteerForm() {
    const [age, setAge] = useState(null);
    const [preferenceCount, setPreferenceCount] = useState(1);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [submitResult, setSubmitResult] = useState(null);

    const form = useForm({
        resolver: zodResolver(formSchema),
        defaultValues: {
            firstName: "",
            middleName: "",
            lastName: "",
            gender: undefined,
            mobileNumber: "",
            email: "",
            addressLine1: "",
            addressLine2: "",
            district: "",
            city: "",
            state: "",
            country: "",
            pincode: "",
            sanghName: "",
            dharmikStudies: "",
            qualification: "",
            specialization: "",
            occupation: undefined,
            occupationOther: "",
            hobbies: "",
            skills: "",
            referredBy: "",
            volunteeringPreference1: undefined,
            volunteeringPreference2: undefined,
            volunteeringPreference3: undefined,
            additionalAreas: [],
            availabilityDays: undefined,
            timeCommitment: "",
            participationMode: undefined,
            pathshalaRole: undefined,
        },
    });

    const dob = form.watch("dob");
    useEffect(() => {
        if (dob) {
            const calculatedAge = differenceInYears(new Date(), dob);
            setAge(calculatedAge);
        }
    }, [dob]);

    async function onSubmit(values) {
        setIsSubmitting(true);
        setSubmitResult(null);

        try {
            const emailExists = await checkEmailExists(values.email);
            if (emailExists) {
                setSubmitResult({
                    success: false,
                    error: 'This email is already registered. Please use a different email address.'
                });
                setIsSubmitting(false);
                return;
            }

            const formDataWithAge = { ...values, age };
            const result = await registerVolunteer(formDataWithAge);

            setSubmitResult(result);

            if (result.success) {
                form.reset();
                setAge(null);
                setPreferenceCount(1);
            }
        } catch (error) {
            console.error('Submit error:', error);
            setSubmitResult({
                success: false,
                error: 'An unexpected error occurred. Please try again.'
            });
        } finally {
            setIsSubmitting(false);
        }
    }

    const onError = (errors, e) => {
        // Wait for state update to reflect in DOM
        setTimeout(() => {
            const firstErrorElement = document.querySelector('[aria-invalid="true"], [data-invalid="true"]');
            if (firstErrorElement) {
                firstErrorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
                firstErrorElement.focus({ preventScroll: true });
            }
        }, 100);
    }

    return (
        <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit, onError)} className="space-y-8">

                {/* 1. Personal Information */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <User className="mr-2 h-6 w-6" /> Personal Information
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="grid grid-cols-1 md:grid-cols-3 gap-6 p-4 md:p-8 pt-2">
                        <FormField
                            control={form.control}
                            name="firstName"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>First Name <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="Enter first name" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="middleName"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Middle Name <span className="text-gray-400 font-normal">(Optional)</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="Enter middle name" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="lastName"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Last Name <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="Enter last name" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <FormField
                            control={form.control}
                            name="dob"
                            render={({ field }) => (
                                <FormItem className="flex flex-col">
                                    <FormLabel>Date of Birth <span className="text-red-500">*</span></FormLabel>
                                    <Popover>
                                        <PopoverTrigger asChild>
                                            <FormControl>
                                                <Button
                                                    variant={"outline"}
                                                    className={cn(
                                                        "pl-3 text-left font-normal",
                                                        !field.value && "text-muted-foreground"
                                                    )}
                                                >
                                                    {field.value ? (
                                                        format(field.value, "PPP")
                                                    ) : (
                                                        <span>Pick a date</span>
                                                    )}
                                                    <CalendarIcon className="ml-auto h-4 w-4 opacity-50" />
                                                </Button>
                                            </FormControl>
                                        </PopoverTrigger>
                                        <PopoverContent className="w-auto p-0 z-[100] bg-white shadow-xl max-w-[min(320px,calc(100vw-2rem))]" align="start">
                                            <Calendar
                                                mode="single"
                                                selected={field.value}
                                                onSelect={field.onChange}
                                                disabled={(date) =>
                                                    date > new Date() || date < new Date("1900-01-01")
                                                }
                                                initialFocus
                                                captionLayout="dropdown"
                                                fromYear={1950}
                                                toYear={new Date().getFullYear()}
                                            />
                                        </PopoverContent>
                                    </Popover>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <div className="space-y-2">
                            <Label>Age</Label>
                            <Input disabled value={age !== null ? `${age} years` : "-"} className="bg-gray-100" />
                        </div>

                        <FormField
                            control={form.control}
                            name="gender"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Gender <span className="text-red-500">*</span></FormLabel>
                                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                                        <FormControl>
                                            <SelectTrigger>
                                                <SelectValue placeholder="Select gender" />
                                            </SelectTrigger>
                                        </FormControl>
                                        <SelectContent className="bg-white">
                                            <SelectItem value="Male">Male</SelectItem>
                                            <SelectItem value="Female">Female</SelectItem>
                                        </SelectContent>
                                    </Select>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                {/* 2. Contact Information */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <Phone className="mr-2 h-6 w-6" /> Contact Information
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-6">
                        <FormField
                            control={form.control}
                            name="mobileNumber"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Mobile Number <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="+91 XXXXX XXXXX" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="email"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Email Address <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="email@example.com" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                {/* 3. Address */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <MapPin className="mr-2 h-6 w-6" /> Residential Address
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-6">
                        <FormField
                            control={form.control}
                            name="addressLine1"
                            render={({ field }) => (
                                <FormItem className="col-span-1 md:col-span-2">
                                    <FormLabel>Address Line 1 <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="Building / House No., Apartment Name" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="addressLine2"
                            render={({ field }) => (
                                <FormItem className="col-span-1 md:col-span-2">
                                    <FormLabel>Address Line 2 <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="Street / Locality / Area" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="city"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>City <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="City" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="district"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>District <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="District" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="sanghName"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Sangh Name <span className="text-gray-400 font-normal">(Optional)</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="Your Sangh Name" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="state"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>State / Province <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="State" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="country"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Country <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="Country" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="pincode"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Postal Code (PIN) <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="PIN Code" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                {/* 4. Educational & Dharmik Background */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <GraduationCap className="mr-2 h-10 w-10" /> Educational & Dharmik Background
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-6">
                        <FormField
                            control={form.control}
                            name="dharmikStudies"
                            render={({ field }) => (
                                <FormItem className="col-span-1 md:col-span-2">
                                    <FormLabel>Dharmik Studies <span className="text-gray-400 font-normal">(Optional)</span></FormLabel>
                                    <FormControl>
                                        <Textarea
                                            placeholder="Mention any Jain religious education, courses, Pathshala learning, scriptures studied..."
                                            className="resize-none"
                                            {...field}
                                        />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="qualification"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Highest Qualification (completed / pursuing) <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="e.g. B.Tech, MBA, PhD" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="specialization"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Field of Study / Specialization <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <Input placeholder="e.g. Computer Science, Finance, Arts" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                {/* 5. Occupation */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <Briefcase className="mr-2 h-6 w-6" /> Current Occupation Status
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-6 pt-6">
                        <FormField
                            control={form.control}
                            name="occupation"
                            render={({ field }) => (
                                <FormItem className="space-y-3">
                                    <FormLabel>Current Status <span className="text-red-500">*</span></FormLabel>
                                    <FormControl>
                                        <RadioGroup
                                            onValueChange={field.onChange}
                                            defaultValue={field.value}
                                            className="flex flex-col space-y-1"
                                        >
                                            {["Student", "Working Professional", "Freelancer / Self-Employed", "Homemaker", "Other"].map((item) => (
                                                <FormItem key={item} className="flex items-center space-x-3 space-y-0">
                                                    <FormControl>
                                                        <RadioGroupItem value={item} />
                                                    </FormControl>
                                                    <FormLabel className="font-normal">
                                                        {item}
                                                    </FormLabel>
                                                </FormItem>
                                            ))}
                                        </RadioGroup>
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        {form.watch("occupation") === "Other" && (
                            <FormField
                                control={form.control}
                                name="occupationOther"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Please Specify</FormLabel>
                                        <FormControl>
                                            <Input placeholder="Specify your occupation" {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                        )}
                    </CardContent>
                </Card>

                {/* 6. Interests & Capabilities */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <Heart className="mr-2 h-6 w-6" /> Interests & Capabilities
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-6">
                        <FormField
                            control={form.control}
                            name="hobbies"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Hobbies & Interests</FormLabel>
                                    <FormControl>
                                        <Textarea placeholder="Activities you enjoy..." className="resize-none" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                        <FormField
                            control={form.control}
                            name="skills"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Skills & Expertise</FormLabel>
                                    <FormControl>
                                        <Textarea placeholder="Technical, creative, or other skills..." className="resize-none" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                {/* 7. Referral */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <LinkIcon className="mr-2 h-6 w-6" /> Referral Information
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="pt-6">
                        <FormField
                            control={form.control}
                            name="referredBy"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Referred By</FormLabel>
                                    <FormControl>
                                        <Input placeholder="Name of person or source" {...field} />
                                    </FormControl>
                                    <FormDescription>Optional: Contact details if applicable</FormDescription>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                {/* 8. Areas of Volunteering Interest */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <div className="flex justify-between items-center">
                            <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                                <CheckSquare className="mr-2 h-6 w-6" /> Areas of Volunteering Interest
                            </CardTitle>
                            <a
                                href="/interests"
                                target="_blank"
                                className="flex items-center gap-1.5 text-xs font-bold text-[#ae2b2b] hover:underline bg-white px-3 py-1.5 rounded-full border border-[#ae2b2b]/20 shadow-sm transition-all hover:shadow-md"
                            >
                                <Info className="h-3.5 w-3.5" /> Know about each area of interest
                            </a>
                        </div>
                    </CardHeader>
                    <CardContent className="pt-6">
                        <div className="space-y-6">
                            <FormField
                                control={form.control}
                                name="volunteeringPreference1"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel className="text-lg font-medium">1st Preference (Compulsory) <span className="text-red-500">*</span></FormLabel>
                                        <FormControl>
                                            <RadioGroup
                                                onValueChange={field.onChange}
                                                defaultValue={field.value}
                                                className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3"
                                            >
                                                {volunteeringOptions.map((option) => {
                                                    const Icon = option.icon;
                                                    return (
                                                        <FormItem key={option.label} className="flex items-center space-x-3 space-y-0 p-3 border rounded-md hover:bg-gray-50 transition-colors">
                                                            <FormControl>
                                                                <RadioGroupItem value={option.label} id={`p1-${option.label}`} />
                                                            </FormControl>
                                                            <FormLabel htmlFor={`p1-${option.label}`} className="font-normal cursor-pointer w-full flex items-center gap-2">
                                                                <Icon className="h-4 w-4 text-[#ae2b2b] flex-shrink-0" />
                                                                <span>{option.label}</span>
                                                            </FormLabel>
                                                        </FormItem>
                                                    );
                                                })}
                                            </RadioGroup>
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            {preferenceCount >= 2 && (
                                <FormField
                                    control={form.control}
                                    name="volunteeringPreference2"
                                    render={({ field }) => {
                                        const prev1 = form.watch("volunteeringPreference1");
                                        return (
                                            <FormItem className="animate-in fade-in slide-in-from-top-4 duration-500">
                                                <div className="flex justify-between items-center mb-2">
                                                    <FormLabel className="text-lg font-medium">2nd Preference</FormLabel>
                                                    <Button
                                                        type="button"
                                                        variant="ghost"
                                                        size="sm"
                                                        className="text-red-500 hover:text-red-700 hover:bg-red-50"
                                                        onClick={() => {
                                                            form.setValue("volunteeringPreference2", undefined);
                                                            if (preferenceCount === 3) {
                                                                const pref3 = form.getValues("volunteeringPreference3");
                                                                form.setValue("volunteeringPreference2", pref3);
                                                                form.setValue("volunteeringPreference3", undefined);
                                                            }
                                                            setPreferenceCount(preferenceCount - 1);
                                                        }}
                                                    >
                                                        <Trash2 className="w-4 h-4 mr-1" /> Remove
                                                    </Button>
                                                </div>
                                                <FormControl>
                                                    <RadioGroup
                                                        onValueChange={field.onChange}
                                                        defaultValue={field.value}
                                                        className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3"
                                                    >
                                                        {volunteeringOptions.map((option) => {
                                                            const Icon = option.icon;
                                                            const isDisabled = option.label === prev1;
                                                            return (
                                                                <FormItem key={option.label}
                                                                    className={cn(
                                                                        "flex items-center space-x-3 space-y-0 p-3 border rounded-md transition-colors",
                                                                        isDisabled ? "opacity-50 bg-gray-100 cursor-not-allowed" : "hover:bg-gray-50"
                                                                    )}
                                                                >
                                                                    <FormControl>
                                                                        <RadioGroupItem value={option.label} disabled={isDisabled} id={`p2-${option.label}`} />
                                                                    </FormControl>
                                                                    <FormLabel htmlFor={`p2-${option.label}`} className={cn("font-normal w-full flex items-center gap-2", isDisabled ? "cursor-not-allowed" : "cursor-pointer")}>
                                                                        <Icon className="h-4 w-4 text-[#ae2b2b] flex-shrink-0" />
                                                                        <span className="flex-1">
                                                                            {option.label}
                                                                            {isDisabled && <span className="block text-xs text-red-500">(Selected in 1st Preference)</span>}
                                                                        </span>
                                                                    </FormLabel>
                                                                </FormItem>
                                                            )
                                                        })}
                                                    </RadioGroup>
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )
                                    }}
                                />
                            )}

                            {/* Conditional Pathshala Question */}
                            {(form.watch("volunteeringPreference1") === "Inhouse Pathshala and Home Schooling" ||
                                form.watch("volunteeringPreference2") === "Inhouse Pathshala and Home Schooling" ||
                                form.watch("volunteeringPreference3") === "Inhouse Pathshala and Home Schooling") && (
                                    <FormField
                                        control={form.control}
                                        name="pathshalaRole"
                                        render={({ field }) => (
                                            <FormItem className="animate-in fade-in slide-in-from-top-4 duration-500 bg-red-50 p-4 rounded-lg border border-red-100">
                                                <FormLabel className="text-lg font-medium text-[#ae2b2b]">
                                                    Preferred Area for Pathshala / Home Schooling?
                                                </FormLabel>
                                                <FormControl>
                                                    <RadioGroup
                                                        onValueChange={field.onChange}
                                                        defaultValue={field.value}
                                                        className="flex flex-col md:flex-row gap-4 mt-2"
                                                    >
                                                        {["Religious teaching", "Academic teaching", "Both"].map((item) => (
                                                            <FormItem key={item} className="flex items-center space-x-2 space-y-0">
                                                                <FormControl>
                                                                    <RadioGroupItem value={item} />
                                                                </FormControl>
                                                                <FormLabel className="font-normal cursor-pointer">
                                                                    {item}
                                                                </FormLabel>
                                                            </FormItem>
                                                        ))}
                                                    </RadioGroup>
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )}
                                    />
                                )}

                            {preferenceCount >= 3 && (
                                <FormField
                                    control={form.control}
                                    name="volunteeringPreference3"
                                    render={({ field }) => {
                                        const prev1 = form.watch("volunteeringPreference1");
                                        const prev2 = form.watch("volunteeringPreference2");
                                        return (
                                            <FormItem className="animate-in fade-in slide-in-from-top-4 duration-500">
                                                <div className="flex justify-between items-center mb-2">
                                                    <FormLabel className="text-lg font-medium">3rd Preference</FormLabel>
                                                    <Button
                                                        type="button"
                                                        variant="ghost"
                                                        size="sm"
                                                        className="text-red-500 hover:text-red-700 hover:bg-red-50"
                                                        onClick={() => {
                                                            form.setValue("volunteeringPreference3", undefined);
                                                            setPreferenceCount(2);
                                                        }}
                                                    >
                                                        <Trash2 className="w-4 h-4 mr-1" /> Remove
                                                    </Button>
                                                </div>
                                                <FormControl>
                                                    <RadioGroup
                                                        onValueChange={field.onChange}
                                                        defaultValue={field.value}
                                                        className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3"
                                                    >
                                                        {volunteeringOptions.map((option) => {
                                                            const Icon = option.icon;
                                                            const isDisabled = option.label === prev1 || option.label === prev2;
                                                            return (
                                                                <FormItem key={option.label}
                                                                    className={cn(
                                                                        "flex items-center space-x-3 space-y-0 p-3 border rounded-md transition-colors",
                                                                        isDisabled ? "opacity-50 bg-gray-100 cursor-not-allowed" : "hover:bg-gray-50"
                                                                    )}
                                                                >
                                                                    <FormControl>
                                                                        <RadioGroupItem value={option.label} disabled={isDisabled} id={`p3-${option.label}`} />
                                                                    </FormControl>
                                                                    <FormLabel htmlFor={`p3-${option.label}`} className={cn("font-normal w-full flex items-center gap-2", isDisabled ? "cursor-not-allowed" : "cursor-pointer")}>
                                                                        <Icon className="h-4 w-4 text-[#ae2b2b] flex-shrink-0" />
                                                                        <span className="flex-1">
                                                                            {option.label}
                                                                            {isDisabled && <span className="block text-xs text-red-500">(Already selected)</span>}
                                                                        </span>
                                                                    </FormLabel>
                                                                </FormItem>
                                                            )
                                                        })}
                                                    </RadioGroup>
                                                </FormControl>
                                                <FormMessage />
                                            </FormItem>
                                        )
                                    }}
                                />
                            )}

                            {preferenceCount < 3 && (
                                <Button
                                    type="button"
                                    variant="outline"
                                    className="w-full md:w-auto text-[#ae2b2b] border-[#ae2b2b]/50 hover:bg-red-50"
                                    onClick={() => setPreferenceCount(preferenceCount + 1)}
                                >
                                    <PlusCircle className="mr-2 h-4 w-4" />
                                    Add {preferenceCount === 1 ? "2nd" : "3rd"} Preference
                                </Button>
                            )}

                            {/* Separator for Additional Interests */}
                            <Separator className="my-6 bg-gray-200" />

                            {/* Additional Interests Checkboxes */}
                            <FormField
                                control={form.control}
                                name="additionalAreas"
                                render={() => (
                                    <FormItem>
                                        <div className="mb-4">
                                            <FormLabel className="text-lg font-medium">Additional Areas of Interest</FormLabel>
                                            <FormDescription>
                                                Select any of these special areas you would like to contribute to (Optional).
                                            </FormDescription>
                                        </div>
                                        <div className="grid grid-cols-1 gap-3">
                                            {additionalOptions.map((option) => {
                                                const Icon = option.icon;
                                                return (
                                                    <FormField
                                                        key={option.label}
                                                        control={form.control}
                                                        name="additionalAreas"
                                                        render={({ field }) => {
                                                            return (
                                                                <FormItem
                                                                    key={option.label}
                                                                    className="flex flex-row items-center space-x-3 space-y-0 rounded-md border p-4 hover:bg-gray-50 transition-colors"
                                                                >
                                                                    <FormControl>
                                                                        <Checkbox
                                                                            checked={field.value?.includes(option.label)}
                                                                            onCheckedChange={(checked) => {
                                                                                return checked
                                                                                    ? field.onChange([...field.value, option.label])
                                                                                    : field.onChange(
                                                                                        field.value?.filter(
                                                                                            (value) => value !== option.label
                                                                                        )
                                                                                    )
                                                                            }}
                                                                        />
                                                                    </FormControl>
                                                                    <FormLabel className="font-normal cursor-pointer w-full flex items-center gap-2">
                                                                        <Icon className="h-4 w-4 text-[#ae2b2b] flex-shrink-0" />
                                                                        {option.label}
                                                                    </FormLabel>
                                                                </FormItem>
                                                            )
                                                        }}
                                                    />
                                                )
                                            })}
                                        </div>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                        </div>
                    </CardContent>
                </Card>

                {/* 9. Availability & Mode */}
                <Card className="border-l-4 border-l-[#ae2b2b]">
                    <CardHeader className="bg-gray-50/50">
                        <CardTitle className="flex items-center text-[#ae2b2b] font-serif tracking-wide text-xl md:text-2xl">
                            <Clock className="mr-2 h-6 w-6" /> Availability & Participation
                        </CardTitle>
                    </CardHeader>
                    <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-8 pt-6">

                        {/* Availability */}
                        <div className="space-y-6">
                            <h3 className="font-semibold text-gray-700 flex items-center">
                                Days Available <span className="text-red-500 ml-1">*</span>
                            </h3>
                            <FormField
                                control={form.control}
                                name="availabilityDays"
                                render={({ field }) => (
                                    <FormItem className="space-y-3">
                                        <FormControl>
                                            <RadioGroup
                                                onValueChange={field.onChange}
                                                defaultValue={field.value}
                                                className="flex flex-col space-y-1"
                                            >
                                                <FormItem className="flex items-center space-x-3 space-y-0">
                                                    <FormControl><RadioGroupItem value="Weekdays" /></FormControl>
                                                    <FormLabel className="font-normal">Weekdays</FormLabel>
                                                </FormItem>
                                                <FormItem className="flex items-center space-x-3 space-y-0">
                                                    <FormControl><RadioGroupItem value="Weekends" /></FormControl>
                                                    <FormLabel className="font-normal">Weekends</FormLabel>
                                                </FormItem>
                                                <FormItem className="flex items-center space-x-3 space-y-0">
                                                    <FormControl><RadioGroupItem value="Flexible" /></FormControl>
                                                    <FormLabel className="font-normal">Flexible</FormLabel>
                                                </FormItem>
                                            </RadioGroup>
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                            <FormField
                                control={form.control}
                                name="timeCommitment"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Weekly Time Commitment (Approx)</FormLabel>
                                        <Select onValueChange={field.onChange} defaultValue={field.value}>
                                            <FormControl>
                                                <SelectTrigger>
                                                    <SelectValue placeholder="Select committed time" />
                                                </SelectTrigger>
                                            </FormControl>
                                            <SelectContent className="bg-white max-h-60 overflow-y-auto">
                                                {[
                                                    "30 mins", "1 hour", "1 hour 30 mins", "2 hours", "2 hours 30 mins",
                                                    "3 hours", "3 hours 30 mins", "4 hours", "4 hours 30 mins",
                                                    "5 hours", "5 hours 30 mins", "6 hours", "6 hours 30 mins",
                                                    "7 hours", "7 hours 30 mins", "8 hours", "8 hours 30 mins",
                                                    "9 hours", "9 hours 30 mins", "10 hours", "10 hours 30 mins",
                                                    "11 hours", "11 hours 30 mins", "12 hours", "12+ hours"
                                                ].map((time) => (
                                                    <SelectItem key={time} value={time}>
                                                        {time}
                                                    </SelectItem>
                                                ))}
                                            </SelectContent>
                                        </Select>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                        </div>

                        {/* Mode of Participation */}
                        <div className="space-y-6">
                            <h3 className="font-semibold text-gray-700 flex items-center">
                                <HandHeart className="mr-2 h-4 w-4" /> Mode of Participation <span className="text-red-500 ml-1">*</span>
                            </h3>
                            <FormField
                                control={form.control}
                                name="participationMode"
                                render={({ field }) => (
                                    <FormItem className="space-y-3">
                                        <FormControl>
                                            <RadioGroup
                                                onValueChange={field.onChange}
                                                defaultValue={field.value}
                                                className="flex flex-col space-y-1"
                                            >
                                                <FormItem className="flex items-center space-x-3 space-y-0">
                                                    <FormControl><RadioGroupItem value="Voluntary (Seva-based)" /></FormControl>
                                                    <FormLabel className="font-normal">Voluntary (Seva-based)</FormLabel>
                                                </FormItem>
                                                <FormItem className="flex items-center space-x-3 space-y-0">
                                                    <FormControl><RadioGroupItem value="Paid Basis (Project or Role-based)" /></FormControl>
                                                    <FormLabel className="font-normal">Paid Basis (Project or Role-based)</FormLabel>
                                                </FormItem>
                                                <FormItem className="flex items-center space-x-3 space-y-0">
                                                    <FormControl><RadioGroupItem value="Flexible / Open to Discussion" /></FormControl>
                                                    <FormLabel className="font-normal">Flexible / Open to Discussion</FormLabel>
                                                </FormItem>
                                            </RadioGroup>
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                        </div>

                    </CardContent>
                </Card>

                <Card className="border-l-4 border-l-[#ae2b2b] bg-gray-50/30">
                    <CardContent className="p-6">
                        <div className="flex items-start space-x-3">
                            <Checkbox id="policy-ack" required />
                            <div className="grid gap-1.5 leading-none">
                                <label
                                    htmlFor="policy-ack"
                                    className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                                >
                                    I acknowledge that I have read and understood the organization's policies, including the Code of Conduct and Appraisal Plan.
                                </label>
                                <p className="text-sm text-muted-foreground">
                                    You can view the full policies <a href="/policies" target="_blank" className="text-[#ae2b2b] font-semibold hover:underline">here</a>.
                                </p>
                            </div>
                        </div>
                    </CardContent>
                </Card>

                {/* Success/Error Messages */}
                {submitResult && (
                    <div className={`rounded-lg p-6 ${submitResult.success ? 'bg-green-50 border border-green-200' : 'bg-red-50 border border-red-200'}`}>
                        {submitResult.success ? (
                            <div className="text-center space-y-4">
                                <div className="flex justify-center">
                                    <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center">
                                        <CheckSquare className="w-8 h-8 text-green-600" />
                                    </div>
                                </div>
                                <h3 className="text-2xl font-bold text-green-800">Registration Successful!</h3>
                                <div className="bg-white rounded-lg p-4 inline-block shadow-sm">
                                    <p className="text-gray-600 text-sm">Your ILJ ID</p>
                                    <p className="text-3xl font-bold text-[#ae2b2b]">{submitResult.ilj_id}</p>
                                </div>
                                <p className="text-green-700">
                                    An email has been sent to your registered email address with your login credentials.
                                </p>
                                <p className="text-sm text-gray-500">
                                    Please check your email for your ILJ ID and Password.
                                </p>
                                <p className="text-xs text-[#ae2b2b] bg-[#ae2b2b]/5 p-2 rounded">
                                    ⚠️ Please change your password after your first login.
                                </p>
                            </div>
                        ) : (
                            <div className="text-center space-y-2">
                                <h3 className="text-xl font-bold text-red-800">Registration Failed</h3>
                                <p className="text-red-600">{submitResult.error}</p>
                            </div>
                        )}
                    </div>
                )}

                {/* Submit Button - Hidden if successful */}
                {(!submitResult || !submitResult.success) && (
                    <div className="flex justify-center pt-8">
                        <Button
                            type="submit"
                            disabled={isSubmitting}
                            className="bg-[#ae2b2b] hover:bg-[#8f1f1f] text-white px-10 py-6 text-xl rounded-full shadow-lg hover:shadow-xl transition-all flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            {isSubmitting ? (
                                <>
                                    <span className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></span>
                                    Submitting...
                                </>
                            ) : (
                                <>
                                    Submit Registration <Send className="w-5 h-5" />
                                </>
                            )}
                        </Button>
                    </div>
                )}
            </form>
        </Form>
    );
}
