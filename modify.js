const fs = require('fs');

const path = 'c:/Users/Asus/Desktop/ILJ/frontend/src/pages/admin/AdminEventRegistrations.jsx';
let content = fs.readFileSync(path, 'utf8');

// Add Fragment to React import
content = content.replace(
    /import { useState, useEffect } from 'react';/,
    "import { useState, useEffect, Fragment } from 'react';"
);

// Map iteration replacement
content = content.replace(
    /\{registrations\.map\(\(reg\) => \([\s\S]*?<tr [\s\S]*?key=\{reg\.id\} [\s\S]*?className="hover:bg-gray-50\/50 transition-colors cursor-pointer"[\s\S]*?onClick=\{[\s\S]*?\}\s*>/,
    \{registrations.map((reg) => (
        <Fragment key={reg.id}>
            <tr 
                className={\\\hover:bg-gray-50/50 transition-colors cursor-pointer \\\\}
                onClick={() => setSelectedReg(selectedReg?.id === reg.id ? null : reg)}\ + "\\n            >"
);

// Update setSelectedReg in the View button
content = content.replace(
    /setSelectedReg\(reg\);/g,
    "setSelectedReg(selectedReg?.id === reg.id ? null : reg);"
);

// Find the modal string 
// We will extract the inner content of the modal starting from <div className="p-6 space-y-6"> to the end of the modal.
const modalContentRegex = /<div className="p-6 space-y-6">([\s\S]*?)<\/div>\s*<\/div>\s*<\/div>\s*\)\}/;
const match = content.match(modalContentRegex);

if (match) {
    let detailsContent = match[1];
    
    // We will append the expanded row logic right after the closing </tr> within the map loop
    content = content.replace(
        /<\/tr>(\s*)(\}\)\})\s*<\/tbody>/,
        \</tr>
            {selectedReg?.id === reg.id && (
                <tr className="bg-gray-50/60 border-b-2 border-blue-500/20 shadow-[inset_0_4px_6px_-4px_rgba(0,0,0,0.1)]">
                    <td colSpan="6" className="p-8 px-12">
                        <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-8 space-y-6 relative overflow-hidden">
                            \
                        </div>
                    </td>
                </tr>
            )}
        </Fragment>\\</tbody >\
    );

    // After successfully embedding it, we remove the modal code at the very bottom
    content = content.replace(/\{\/\* Registration Details Modal \*\/\}[\s\S]*?<\/div>\s*\}\)\s*<\/div>\s*\)\s*\}\s*export/m, "</div>\\n    );\\n}\\n\\nexport");
}


fs.writeFileSync(path, content);
console.log('Done!');
