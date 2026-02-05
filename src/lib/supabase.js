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

        // Prepare the data for RPC
        const rpcParams = {
            p_first_name: formData.firstName,
            p_middle_name: formData.middleName || null,
            p_last_name: formData.lastName,
            p_dob: `${formData.dob.getFullYear()}-${String(formData.dob.getMonth() + 1).padStart(2, '0')}-${String(formData.dob.getDate()).padStart(2, '0')}`,
            p_age: formData.age || null,
            p_gender: formData.gender,
            p_mobile_number: formData.mobileNumber,
            p_email: formData.email,
            p_address_line1: formData.addressLine1,
            p_address_line2: formData.addressLine2 || null,
            p_district: formData.district,
            p_city: formData.city,
            p_state: formData.state,
            p_country: formData.country,
            p_pincode: formData.pincode,
            p_sangh_name: formData.sanghName || null,
            p_dharmik_studies: formData.dharmikStudies || null,
            p_qualification: formData.qualification,
            p_specialization: formData.specialization,
            p_occupation: formData.occupation,
            p_occupation_other: formData.occupationOther || null,
            p_hobbies: formData.hobbies || null,
            p_skills: formData.skills || null,
            p_referred_by: formData.referredBy || null,
            p_volunteering_preference1: formData.volunteeringPreference1,
            p_volunteering_preference2: formData.volunteeringPreference2 || null,
            p_volunteering_preference3: formData.volunteeringPreference3 || null,
            p_availability_days: formData.availabilityDays,
            p_time_commitment: formData.timeCommitment || null,
            p_participation_mode: formData.participationMode,
            p_additional_areas: formData.additionalAreas || null,
            p_password_hash: generatedPassword,
        };

        const { data, error } = await supabase.rpc('register_volunteer_secure', rpcParams);

        if (error) {
            console.error('Registration RPC error:', error);
            return {
                success: false,
                error: error.message || 'Failed to register volunteer'
            };
        }

        if (!data.success) {
            return {
                success: false,
                error: data.error
            };
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
