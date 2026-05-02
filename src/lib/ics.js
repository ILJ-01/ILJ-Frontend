/**
 * Generates an .ics file content for calendar events
 * @param {Object} event - Event details
 * @param {string} event.title - Event title
 * @param {string} event.description - Event description
 * @param {Date} event.startTime - Start Date object
 * @param {Date} event.endTime - End Date object
 * @param {string} [event.location] - Event location
 */
export function generateICS(event) {
    const formatDate = (date) => {
        if (!date) return '';
        const d = new Date(date);
        return d.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z';
    };

    const start = formatDate(event.startTime);
    const end = formatDate(event.endTime) || start; // Default to start if no end

    const icsContent = [
        'BEGIN:VCALENDAR',
        'VERSION:2.0',
        'PRODID:-//ILJ//Event//EN',
        'BEGIN:VEVENT',
        `UID:${Math.random().toString(36).substring(2)}@ilj.org`,
        `DTSTAMP:${formatDate(new Date())}`,
        `DTSTART:${start}`,
        `DTEND:${end}`,
        `SUMMARY:${event.title}`,
        `DESCRIPTION:${(event.description || '').replace(/\n/g, '\\n')}`,
        event.location ? `LOCATION:${event.location}` : '',
        'END:VEVENT',
        'END:VCALENDAR'
    ].filter(Boolean).join('\r\n');

    return icsContent;
}

export function downloadICS(event, filename = 'event.ics') {
    const icsContent = generateICS(event);
    const blob = new Blob([icsContent], { type: 'text/calendar;charset=utf-8' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
