// create-empty-entities.js

const fs = require('fs');
const path = require('path');

const entityDir = path.join(__dirname, 'src', 'entity');

const entityNames = [
    'Account',
    'Admin',
    'Teacher',
    'Student',
    'Parent',
    'Supporter',
    'PastExam',
    'Semester',
    'SemesterInstance',
    'Subject',
    'GradeScale',
    'Grade',
    'AttendanceRecord',
    'AttendanceMonth',
    'Timetable'
];

function createEmptyEntities() {
    // 1. Create the base 'src/entity' directory if it doesn't exist
    if (!fs.existsSync(entityDir)) {
        fs.mkdirSync(entityDir, { recursive: true });
        console.log(`✅ Created directory: ${entityDir}`);
    }

    // 2. Loop through the names and write empty files
    console.log("\nWriting Empty Entity Files...");
    entityNames.forEach(name => {
        const fileName = path.join(entityDir, `${name}.ts`);
        
        try {
            // Write an empty string to create an empty file
            fs.writeFileSync(fileName, ''); 
            console.log(`   - ${name}.ts created successfully.`);
        } catch (err) {
            console.error(`❌ Failed to write file ${fileName}: ${err}`);
        }
    });

    console.log("\n✨ All 15 empty TypeORM Entity files have been created in src/entity/!\\n");
    console.log("➡️ NEXT STEP: Let's create a **Student Controller** to start building your API logic.");
}

createEmptyEntities();