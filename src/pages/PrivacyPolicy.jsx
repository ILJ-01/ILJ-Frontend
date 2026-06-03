import React from 'react';

export default function PrivacyPolicy() {
    return (
        <div className="container mx-auto px-4 py-8 md:py-12 max-w-4xl text-gray-800">
            <h1 className="text-3xl md:text-5xl font-bold font-serif text-[#ae2b2b] mb-6 border-b border-gray-200 pb-4">
                Privacy Policy
            </h1>
            <div className="space-y-6 text-sm md:text-base leading-relaxed">
                <p>
                    <strong>Last Updated: {new Date().toLocaleDateString('en-US', { month: 'long', year: 'numeric' })}</strong>
                </p>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">1. Introduction</h2>
                    <p>
                        Welcome to the I Love Jinshasan (ILJ) platform. We respect your privacy and are committed to protecting it.
                        This Privacy Policy explicitly complies with India's <strong>Digital Personal Data Protection (DPDP) Act, 2023</strong>,
                        the General Data Protection Regulation (GDPR), and other relevant privacy frameworks. It governs how we collect, use,
                        maintain, and protect the data you share when you register as a volunteer, participate in events, or visit our platform.
                    </p>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">2. Data We Collect</h2>
                    <p>When you register as a volunteer or participate in events, we collect specific personal data to facilitate your involvement:</p>
                    <ul className="list-disc pl-6 space-y-1">
                        <li><strong>Personal Identification Data:</strong> Name, age, gender, blood group, marital status.</li>
                        <li><strong>Contact Information:</strong> Email address, phone number, WhatsApp number, residential address.</li>
                        <li><strong>Skills and Background:</strong> Education, occupation, skills, interests (e.g., medical, IT).</li>
                        <li><strong>Platform Activity:</strong> Pod allocations, spiritual task assignments, and event attendance tracking.</li>
                    </ul>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">3. How We Use Your Data</h2>
                    <p>As a Data Fiduciary under the DPDP Act, your data is processed exclusively for specific, lawful purposes:</p>
                    <ul className="list-disc pl-6 space-y-1">
                        <li>To onboard you as an ILJ volunteer and assign you to appropriate pods and projects.</li>
                        <li>To communicate event updates, spiritual tasks, and organizational news.</li>
                        <li>To match your specific skills with community operations (e.g., connecting doctors for medical camps).</li>
                        <li>To maintain platform security and prevent fraudulent registrations.</li>
                    </ul>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">4. Security & Storage</h2>
                    <p>
                        We deploy industry-standard security measures, including role-based access control, encrypted databases, and secure transit protocols (HTTPS) to safeguard your personal data.
                        Only verified IT Administrators and Pod Leaders are granted access to your data, strictly limited to what is necessary for organizational operations.
                    </p>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">5. Data Principal Rights</h2>
                    <p>Under the DPDP Act 2023, you (the Data Principal) possess the following rights regarding your personal data:</p>
                    <ul className="list-disc pl-6 space-y-1">
                        <li><strong>Right to Access:</strong> Request a summary of your personal data processed by us.</li>
                        <li><strong>Right to Correction & Erasure:</strong> Request corrections to inaccurate data or deletion of your data when it is no longer required for the purpose it was collected.</li>
                        <li><strong>Right of Grievance Redressal:</strong> Register complaints regarding your data processing.</li>
                        <li><strong>Right to Nominate:</strong> Nominate an individual to exercise your rights in the event of death or incapacity.</li>
                    </ul>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">6. Cookie Policy</h2>
                    <p>
                        Our platform uses functional cookies to maintain active sessions, apply security protocols, and remember layout preferences based on your administrative roles. We do not use third-party tracking scripts or advertising cookies without explicit consent. By continuing to use the platform, you agree to our functional cookies.
                    </p>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">7. Contact Us</h2>
                    <p>
                        If you have questions about this Privacy Policy, wish to exercise your data rights, or need to contact our Data Protection Officer, please reach out to our administrative team via official ILJ channels.
                    </p>
                </section>
            </div>
        </div>
    );
}
