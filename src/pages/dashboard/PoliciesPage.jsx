import { useState } from "react";
import {
    Shield, Award, Heart, Briefcase, Handshake, Megaphone,
    MessageCircle, Scale, AlertTriangle, CheckCircle, TrendingUp,
    Users, BookOpen, Star, User, ClipboardList, Info
} from "lucide-react";

export default function PoliciesPage() {
    const [activeTab, setActiveTab] = useState("conduct");

    const documents = {
        conduct: {
            id: "conduct",
            title: "Code of Conduct",
            icon: Shield,
            description: "Guidelines and ethical standards for all ILJ team members.",
            sections: [
                {
                    type: "intro",
                    content: [
                        "This Code of Conduct outlines the expected behavior and ethical standards for all volunteers associated with team I Love Jinshasan.",
                        "As a volunteer, you play a vital role in furthering our mission of sharing the principles of Jainism and working towards the progress and well-being of the Jain community. By agreeing to register as a volunteer with us, you commit to upholding these principles in all your interactions and activities."
                    ]
                },
                {
                    title: "Respect and Inclusivity",
                    icon: Heart,
                    content: [
                        "Volunteers will treat all individuals - fellow volunteers, members of the Jain community, and the wider public - with respect, dignity, and courtesy, regardless of their background, beliefs, or identity.",
                        "We are committed to fostering an inclusive environment. Volunteers will actively work to ensure that all individuals feel welcomed, valued, and heard. Discrimination or harassment of any kind will not be tolerated.",
                        "Volunteers will be mindful of cultural sensitivities and strive to understand and appreciate diverse perspectives within the Jain community and beyond."
                    ]
                },
                {
                    title: "Professionalism and Responsibility",
                    icon: Briefcase,
                    content: [
                        "Volunteers will carry out their assigned tasks with dedication, diligence, and to the best of their abilities.",
                        "Volunteers shall keep a check on their dashboard for any new task assigned by the project manager and update the status of the assigned tasks appropriately.",
                        "Volunteers will be punctual and reliable in their commitments. If unable to fulfill a task or commitment, they will communicate this in a timely manner to the relevant coordinator or team leader.",
                        "It is mandatory for each volunteer to submit a periodic timesheet which will be reviewed and approved by the project manager. The timesheet will have details of the time spent for the work done. The timesheet is available on the volunteer's dashboard.",
                        "Volunteers will represent the organization in a positive and professional manner at all times, both in person and online.",
                        "You are required to report promptly, and in good faith, any conduct of any volunteer or third-party agent (that is, a supplier or partner) that could constitute a violation of the Code. If you deliberately fail to report a potential violation, or withhold relevant and material information concerning a violation, you may be subject to disciplinary action, up to and including termination of volunteership. If you have questions regarding the appropriateness of a situation, discuss it with your Team leader."
                    ]
                },
                {
                    title: "Collaboration and Teamwork",
                    icon: Handshake,
                    content: [
                        "Volunteers will work collaboratively with fellow volunteers and staff, fostering a spirit of teamwork and mutual support.",
                        "Volunteers will be open to feedback and willing to learn from others.",
                        "Volunteers will communicate effectively and respectfully with all team members.",
                        "Volunteers will contribute positively to a harmonious and productive working environment."
                    ]
                },
                {
                    title: "Promoting the Organization's Mission",
                    icon: Megaphone,
                    content: [
                        "Volunteers will actively support and promote the organization's mission of spreading the word of Jainism and working for the upliftment of the Jain community.",
                        "When communicating about Jainism, volunteers will strive for accuracy and sensitivity, respecting the diversity of Jain traditions and viewpoints.",
                        "Volunteers will act as positive ambassadors for the Jain faith and the organization."
                    ]
                },
                {
                    title: "Responsible communication",
                    icon: MessageCircle,
                    content: [
                        "The organization's public communications - like our values - reflect our commitment to integrity and transparency.",
                        "We strive for accuracy, transparency, reflecting our values and openness with our community.",
                        "To maintain accuracy and consistency in all the public communications, only designated spokespersons should make public statements on behalf of the organization."
                    ]
                },
                {
                    title: "Conflict Resolution",
                    icon: Scale,
                    content: [
                        "Volunteers are encouraged to address any concerns or conflicts that may arise in a constructive and respectful manner.",
                        "Volunteers will seek guidance from their coordinator / team leader or ultimately from Muktimandan M.S. if they are unable to resolve a conflict independently."
                    ]
                },
                {
                    title: "Consequences of Violations",
                    icon: AlertTriangle,
                    content: [
                        "Failure to adhere to this Code of Conduct may result in disciplinary action, up to and including termination of the volunteer's association with team I Love Jinshasan."
                    ]
                },
                {
                    title: "Acknowledgement",
                    icon: CheckCircle,
                    content: [
                        "By volunteering with team I Love Jinshasan, the volunteers acknowledge that they have read, understood, and agreed to abide by this Code of Conduct."
                    ]
                }
            ]
        },
        appraisal: {
            id: "appraisal",
            title: "Appraisal Plan",
            icon: Award,
            description: "Performance review and growth roadmap.",
            sections: [
                {
                    type: "intro",
                    content: [
                        "This appraisal plan focuses on recognizing contributions, fostering growth, and aligning individual efforts with the group's mission of spreading awareness of Jainism and uplifting the Jain community. It emphasizes a collaborative and supportive environment."
                    ]
                },
                {
                    title: "Hierarchical Structure & Promotion Criteria",
                    icon: TrendingUp,
                    content: [
                        "The team will follow a merit-based hierarchy. Promotions are primarily triggered by the cumulative hours contributed (verified via timesheets) and performance quality."
                    ],
                    table: {
                        headers: ["Title", "Required contribution (cumulative hours)"],
                        rows: [
                            ["Intern", "Entry level"],
                            ["Associate", "10 hours"],
                            ["Assistant Manager", "100 hours"],
                            ["Manager", "500 hours"],
                            ["Senior Manager", "1000 hours"],
                            ["Associate Director", "2000 hours"],
                            ["Director", "4000 hours"]
                        ]
                    },
                    extraContent: [
                        "The appraisal cycle will be of 6 months to allow sufficient time for volunteers to contribute and develop.",
                        "The individual appraisal of volunteers will be done by the project manager of the respective projects. The appraisal of the project manager will be done by the core committee."
                    ]
                },
                {
                    title: "Individual Appraisal Plan",
                    icon: User,
                    content: [
                        "It is primarily based on the assessment of the following parameters:",
                        "• **Productivity and efficiency** in the execution of the allotted work. This will also include the dedication volunteers have shown and the time spent towards the work given to them.",
                        "• **Attendance** in the events and meetings organised by team I Love Jinshasan.",
                        "• **Demonstrating creativity** while fulfilling their responsibilities to create maximum impact and achieve the desired outcome.",
                        "• **Adherence to the Code of Conduct.**"
                    ],
                    subSections: [
                        {
                            subtitle: "Other factors that can be considered for individual appraisal:",
                            content: [
                                "• **Skill-based factors:** Identifying the specific skill sets relevant to your group's activities. Examples include:",
                                "    - **Communication & Outreach:** Public speaking, writing (articles, social media posts), presentation skills.",
                                "    - **Community Engagement:** Networking, allocation of work amongst the team, community organizing.",
                                "    - **Research & Content Development:** Study and research on scriptures and principles of Jainism as well as of other faiths, creating educational materials, translating texts, etc.",
                                "    - **Administration:** Record-keeping, financial management (if required), resource management, scheduling.",
                                "    - **Mentorship & Guidance:** Providing support and guidance to the young and new volunteers, fostering a sense of community.",
                                "• **Peer Feedback:** Volunteers or team leaders may provide feedback for other volunteers which can provide valuable insights into a volunteer's collaborative spirit and impact on team members. If the volunteers or the team leaders have negative feedback for any of the other volunteers or team leaders, it must be reported directly to the core committee. The name of the volunteer providing feedback will be kept confidential.",
                                "• **Team leader/coordinator assessment:** The leader(s) or coordinators of the specific teams will assess each volunteer based on the parameters such as:",
                                "    - **Skill Application:** How effectively the volunteer utilized their identified skills.",
                                "    - **Quality of Work:** The standard and impact of their contributions.",
                                "    - **Initiative & Proactiveness:** Their willingness to take on tasks and contribute ideas.",
                                "    - **Teamwork & Collaboration:** Their ability to work effectively with others.",
                                "    - **Commitment & Reliability:** Their dedication towards their responsibilities."
                            ]
                        },
                        {
                            subtitle: "Status Reports",
                            content: [
                                "The project manager will have to submit a status report on the progress of the work allotted to their team on a monthly basis. This report will be reviewed by the core committee."
                            ]
                        }
                    ]
                },
                {
                    title: "Recognition and Appreciation",
                    icon: Star,
                    content: [
                        "Based on the appraisal, volunteers' contributions will be acknowledged in meaningful ways. This could include:",
                        "• Verbal appreciation during meetings.",
                        "• Certificates of appreciation.",
                        "• Cash prizes or gift vouchers will be given during the award ceremony.",
                        "• Highlighting their achievements in group communications and social media posts (with their permission).",
                        "• Providing opportunities for leadership roles or taking on more responsibility.",
                        "• There are different types of awards which will be given based on the nominations provided by the volunteers such as:",
                        "    - Award for best performance (team wise award)",
                        "    - Award for the best team",
                        "    - Award for the volunteer of the year",
                        "    - And many more"
                    ]
                }
            ]
        }
    };

    // Helper to render text with bold formatting
    const renderText = (text, idx) => {
        const parts = text.split(/(\*\*.*?\*\*)/g);
        const isListItem = text.trim().startsWith("•") || text.trim().startsWith("-");
        const isNestedItem = text.includes("    -");

        return (
            <p key={idx} className={`text-gray-600 mb-2 leading-relaxed ${isNestedItem ? "ml-8" : isListItem ? "ml-4" : ""}`}>
                {parts.map((part, i) =>
                    part.startsWith('**') && part.endsWith('**')
                        ? <strong key={i} className="font-semibold text-gray-900">{part.slice(2, -2)}</strong>
                        : part
                )}
            </p>
        );
    };

    const doc = documents[activeTab];

    return (
        <div className="space-y-6 max-w-5xl mx-auto">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 className="text-2xl font-bold text-gray-900">Organization Policies</h2>
                    <p className="text-gray-500">Official guidelines and documents for the ILJ team.</p>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
                {/* Sidebar */}
                <div className="md:col-span-3 space-y-2">
                    {Object.values(documents).map((d) => {
                        const Icon = d.icon;
                        return (
                            <button
                                key={d.id}
                                onClick={() => setActiveTab(d.id)}
                                className={`w-full text-left p-4 rounded-xl transition-all flex items-center gap-3 border ${activeTab === d.id
                                    ? "bg-white border-[#ae2b2b] shadow-sm ring-1 ring-[#ae2b2b]/20"
                                    : "bg-white/50 border-transparent hover:bg-white hover:shadow-sm text-gray-600"
                                    }`}
                            >
                                <div className={`p-2 rounded-lg ${activeTab === d.id ? "bg-[#ae2b2b] text-white" : "bg-gray-100 text-gray-500"
                                    }`}>
                                    <Icon className="h-5 w-5" />
                                </div>
                                <div>
                                    <p className={`font-semibold text-sm ${activeTab === d.id ? "text-gray-900" : "text-gray-700"
                                        }`}>{d.title}</p>
                                </div>
                            </button>
                        );
                    })}
                </div>

                {/* Content */}
                <div className="md:col-span-9">
                    <div className="bg-white rounded-xl shadow-sm border border-gray-200 min-h-[600px] flex flex-col">
                        <div className="border-b border-gray-100 p-6 bg-gray-50/50">
                            <h3 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                                {activeTab === 'conduct' ? <Shield className="h-5 w-5 text-[#ae2b2b]" /> : <Award className="h-5 w-5 text-[#ae2b2b]" />}
                                {doc.title}
                            </h3>
                            <p className="text-sm text-gray-500 mt-1">{doc.description}</p>
                        </div>

                        <div className="p-8 md:p-10 flex-1">
                            {doc.sections.map((section, idx) => {
                                const SectionIcon = section.icon;
                                return (
                                    <div key={idx} className="mb-8 last:mb-0">
                                        {/* Heading with Icon */}
                                        {section.title && (
                                            <div className="flex items-center gap-3 mb-4 p-2 bg-gray-50 rounded-lg border border-gray-100 inline-flex pr-4">
                                                {SectionIcon && (
                                                    <div className="bg-white p-1.5 rounded-md shadow-sm text-[#ae2b2b]">
                                                        <SectionIcon className="h-5 w-5" />
                                                    </div>
                                                )}
                                                <h3 className="text-lg font-bold text-gray-900">{section.title}</h3>
                                            </div>
                                        )}

                                        {/* Paragraphs */}
                                        {section.content && (
                                            <div className="space-y-1">
                                                {section.content.map((text, i) => renderText(text, i))}
                                            </div>
                                        )}

                                        {/* Table (if any) */}
                                        {section.table && (
                                            <div className="mt-4 mb-6 border border-gray-200 rounded-lg overflow-hidden">
                                                <table className="w-full text-sm text-left">
                                                    <thead className="bg-gray-50 text-gray-700 font-semibold border-b border-gray-200">
                                                        <tr>
                                                            {section.table.headers.map((h, i) => <th key={i} className="px-6 py-3">{h}</th>)}
                                                        </tr>
                                                    </thead>
                                                    <tbody className="divide-y divide-gray-100">
                                                        {section.table.rows.map((row, i) => (
                                                            <tr key={i} className="hover:bg-gray-50">
                                                                {row.map((cell, j) => <td key={j} className="px-6 py-3 text-gray-600">{cell}</td>)}
                                                            </tr>
                                                        ))}
                                                    </tbody>
                                                </table>
                                            </div>
                                        )}

                                        {/* Extra Content (after table) */}
                                        {section.extraContent && (
                                            <div className="space-y-1 mt-4">
                                                {section.extraContent.map((text, i) => renderText(text, i))}
                                            </div>
                                        )}

                                        {/* Subsections (for Appraisal) */}
                                        {section.subSections && (
                                            <div className="mt-6 space-y-6">
                                                {section.subSections.map((sub, i) => (
                                                    <div key={i}>
                                                        <h4 className="text-md font-bold text-gray-800 mb-2">{sub.subtitle}</h4>
                                                        <div className="space-y-1 pl-2 border-l-2 border-[#ae2b2b]/20">
                                                            {sub.content.map((text, j) => renderText(text, j))}
                                                        </div>
                                                    </div>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
