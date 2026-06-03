import React from 'react';

export default function TermsOfService() {
    return (
        <div className="container mx-auto px-4 py-8 md:py-12 max-w-4xl text-gray-800">
            <h1 className="text-3xl md:text-5xl font-bold font-serif text-[#ae2b2b] mb-6 border-b border-gray-200 pb-4">
                Terms & Conditions
            </h1>
            <div className="space-y-6 text-sm md:text-base leading-relaxed">
                <p>
                    <strong>Last Updated: {new Date().toLocaleDateString('en-US', { month: 'long', year: 'numeric' })}</strong>
                </p>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">1. Acceptance of Terms</h2>
                    <p>
                        By accessing, browsing, or using the I Love Jinshasan (ILJ) platform, whether as a visitor, volunteer, or administrator, you agree to abide by these Terms & Conditions.
                        If you do not agree to these terms, you must not use our platform or submit any personal information.
                    </p>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">2. Volunteer Registration & Responsibilities</h2>
                    <p>By registering as a volunteer, you agree that:</p>
                    <ul className="list-disc pl-6 space-y-1">
                        <li>All information you provide is accurate, current, and complete.</li>
                        <li>You will abide by the code of conduct required by the ILJ community and its spiritual leadership.</li>
                        <li>You will not misuse the platform to extract data, harass other members, or engage in unauthorized activities.</li>
                        <li>Your status as a volunteer can be revoked by administrators at any time for policy violations.</li>
                    </ul>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">3. Use of Content</h2>
                    <p>
                        All content, including text, graphics, logos, and software provided on this platform, is the property of I Love Jinshasan.
                        You may not reproduce, distribute, or modify any materials without explicit prior written consent.
                    </p>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">4. Limitation of Liability</h2>
                    <p>
                        The ILJ Platform and its services are provided on an "as is" and "as available" basis.
                        While we strive to ensure the accuracy and security of the platform, we shall not be held liable for any direct, indirect, incidental, or consequential damages resulting from the use or inability to use our platform, or for any unauthorized access to our servers.
                    </p>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">5. Termination</h2>
                    <p>
                        We reserve the right to suspend or terminate your access to the platform without prior notice if we believe you have violated these Terms & Conditions or any applicable DPDP laws regarding the abuse of community data.
                    </p>
                </section>

                <section className="space-y-3">
                    <h2 className="text-xl font-bold text-gray-900 border-l-4 border-[#ae2b2b] pl-3">6. Changes to Terms</h2>
                    <p>
                        We may update these Terms & Conditions periodically to reflect changes in legal or operational requirements. Your continued use of the platform after updates signifies your acceptance of the new terms.
                    </p>
                </section>
            </div>
        </div>
    );
}
