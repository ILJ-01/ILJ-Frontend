import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://pdcgcqsgzupoyzklvoju.supabase.co';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBkY2djcXNnenVwb3l6a2x2b2p1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0OTM0MDUsImV4cCI6MjA4NTA2OTQwNX0.Adh2epzvTt0jmif6x6FdJr0YphHtZ_spciyg9z1Et0s';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Helper to generate random password
function generateRandomPassword(length = 8) {
    const charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    let password = "";
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * charset.length);
        password += charset[randomIndex];
    }
    return password;
}

// Edge function URL for sending emails
export const EDGE_FUNCTION_URL = `${supabaseUrl}/functions/v1/send-welcome-email`;

/**
 * Register a new volunteer
 * @param {Object} formData - The volunteer form data
 * @returns {Promise<{success: boolean, ilj_id?: string, error?: string}>}
 */
export async function registerVolunteer(formData) {
    try {
        const generatedPassword = generateRandomPassword();

        // Prepare the data for insertion
        const volunteerData = {
            first_name: formData.firstName,
            middle_name: formData.middleName || null,
            last_name: formData.lastName,
            dob: `${formData.dob.getFullYear()}-${String(formData.dob.getMonth() + 1).padStart(2, '0')}-${String(formData.dob.getDate()).padStart(2, '0')}`, // Format as YYYY-MM-DD (Local Time)
            age: formData.age || null,
            gender: formData.gender,
            mobile_number: formData.mobileNumber,
            email: formData.email,
            address_line1: formData.addressLine1,
            address_line2: formData.addressLine2 || null,
            district: formData.district,
            city: formData.city,
            state: formData.state,
            country: formData.country,
            pincode: formData.pincode,
            sangh_name: formData.sanghName || null,
            dharmik_studies: formData.dharmikStudies || null,
            qualification: formData.qualification,
            specialization: formData.specialization,
            occupation: formData.occupation,
            occupation_other: formData.occupationOther || null,
            hobbies: formData.hobbies || null,
            skills: formData.skills || null,
            referred_by: formData.referredBy || null,
            volunteering_preference1: formData.volunteeringPreference1,
            volunteering_preference2: formData.volunteeringPreference2 || null,
            volunteering_preference3: formData.volunteeringPreference3 || null,
            availability_days: formData.availabilityDays,
            time_commitment: formData.timeCommitment || null,
            participation_mode: formData.participationMode,
            additional_areas: formData.additionalAreas || null,
            password_hash: generatedPassword, // In production, use proper hashing
        };

        // Insert the volunteer data
        const { data, error } = await supabase
            .from('volunteers')
            .insert(volunteerData)
            .select('ilj_id, first_name, last_name, email')
            .single();

        if (error) {
            console.error('Supabase insert error:', error);
            return {
                success: false,
                error: error.message || 'Failed to register volunteer'
            };
        }

        // Send welcome email with credentials
        try {
            const emailResponse = await fetch(EDGE_FUNCTION_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    to: data.email,
                    ilj_id: data.ilj_id,
                    password: generatedPassword,
                    first_name: data.first_name,
                    last_name: data.last_name,
                }),
            });

            const emailResult = await emailResponse.json();

            if (!emailResponse.ok) {
                console.warn('Email sending failed:', emailResult);
                // Don't fail the registration if email fails
            }
        } catch (emailError) {
            console.warn('Email sending error:', emailError);
            // Don't fail the registration if email fails
        }

        return {
            success: true,
            ilj_id: data.ilj_id,
            message: `Registration successful! Your ILJ ID is ${data.ilj_id}`
        };

    } catch (error) {
        console.error('Registration error:', error);
        return {
            success: false,
            error: error.message || 'An unexpected error occurred'
        };
    }
}

/**
 * Check if email already exists
 * @param {string} email - Email to check
 * @returns {Promise<boolean>}
 */
export async function checkEmailExists(email) {
    const { data, error } = await supabase
        .from('volunteers')
        .select('email')
        .eq('email', email)
        .single();

    if (error && error.code === 'PGRST116') {
        // No rows found
        return false;
    }

    return !!data;
}
