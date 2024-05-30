# Functional Requirements

1. **User Registration and Authentication**
    - Users must be able to register an account.
    - Users must be able to log in to their account.
    - The system must authenticate users upon login.

2. **Clinic Selection**
    - The system must determine the nearest clinic for the user based on location.
    - Users must be able to select a clinic from a list.
    - Users must be able to view details of each clinic, including departments and specializations.

3. **Appointment Management**
    - Users must be able to schedule an appointment with a general practitioner or specialist.
    - Users must be able to view their scheduled appointments.
    - Users must be able to change the date and time of their appointments.
    - Users must be able to cancel their appointments.

4. **Data Storage**
    - The system must store user registration data either locally or via an external service.
    - The system must use a SQLite database for storing data.

5. **Additional Features**
    - The system should support password recovery.
    - The system should provide secure access to user data.

# Text Scenarios

## Scenario 1: User Registration

**Actor:** User

**Preconditions:** The user has the app installed.

**Main Flow:**
1. The user opens the app and navigates to the registration page.
2. The user enters their personal information and submits the registration form.
3. The system stores the user data locally or via an external service.
4. The system confirms registration and redirects the user to the login page.

**Postconditions:** The user is registered and can log in.

## Scenario 2: User Login

**Actor:** User

**Preconditions:** The user is registered.

**Main Flow:**
1. The user opens the app and navigates to the login page.
2. The user enters their username and password.
3. The system authenticates the user.
4. Upon successful authentication, the system grants access to the user's dashboard.

**Postconditions:** The user is logged in and can access the app's features.

## Scenario 3: Clinic Selection

**Actor:** User

**Preconditions:** The user is logged in.

**Main Flow:**
1. The user navigates to the clinic selection page.
2. The system determines the nearest clinic based on the user's location.
3. The user can choose the nearest clinic or select a different clinic from the list.
4. The user can view clinic details including departments and specializations.

**Postconditions:** The user has selected a clinic.

## Scenario 4: Appointment Scheduling

**Actor:** User

**Preconditions:** The user is logged in and has selected a clinic.

**Main Flow:**
1. The user navigates to the appointment scheduling page.
2. The user selects a general practitioner or specialist.
3. The user chooses a date and time for the appointment.
4. The system confirms the appointment and stores the details.

**Postconditions:** The user has scheduled an appointment.

## Scenario 5: Checking Appointments

**Actor:** User

**Preconditions:** The user is logged in and has scheduled appointments.

**Main Flow:**
1. The user navigates to the appointments page.
2. The system displays a list of the user's scheduled appointments.

**Postconditions:** The user can view their scheduled appointments.

## Scenario 6: Changing Appointment Date and Time

**Actor:** User

**Preconditions:** The user is logged in and has a scheduled appointment.

**Main Flow:**
1. The user navigates to the appointments page and selects an appointment.
2. The user chooses a new date and time for the appointment.
3. The system updates the appointment details.

**Postconditions:** The user has rescheduled the appointment.

## Scenario 7: Canceling an Appointment

**Actor:** User

**Preconditions:** The user is logged in and has a scheduled appointment.

**Main Flow:**
1. The user navigates to the appointments page and selects an appointment.
2. The user cancels the appointment.
3. The system removes the appointment from the user's schedule.

**Postconditions:** The user has canceled the appointment.

# UML diagrams

## Component diagram
<img width="640" alt="Снимок экрана 2024-05-30 в 16 14 00" src="https://github.com/fpmi-tp2024/tpmp-gpd-lab10-hryakopluxi/assets/60287872/cfb7ed72-d000-433d-9057-012174756d90">

# Use Case Diagram

<img width="525" alt="Снимок экрана 2024-05-30 в 16 00 30" src="https://github.com/fpmi-tp2024/tpmp-gpd-lab10-hryakopluxi/assets/60287872/7144e873-4e4c-4351-9cfd-f3455d756ee0">

## Deployment diagram
<img width="356" alt="Снимок экрана 2024-05-30 231910" src="https://github.com/fpmi-tp2024/tpmp-gpd-lab10-hryakopluxi/assets/60287872/c84d5a51-65c3-49cb-b51e-4360fb2589db">


# Additional Specification

## 1. Constraints
- The application must be compatible with MacOS 10.15 or newer.
- The application must use SQLite as the database for storing user and appointment data.
- The application must be developed in Swift 5.0 or newer.
- The application must be able to function offline for viewing previously stored data but require an internet connection for syncing data with external services or for real-time location services.

## 2. Security Requirements
- All user data must be encrypted both at rest and in transit.
- Passwords must be stored securely.
- User access must be controlled through a robust authentication mechanism.
- User personal information must be protected and only accessible to authorized personnel.
- Users must have control over their data, including the ability to view, modify, and delete their information.
- The application must implement and display a clear privacy policy outlining data usage and protection measures.

## 3. Reliability Requirements
- The application must have an uptime of at least 99.5%, ensuring that it is available for users to book, cancel, or reschedule appointments at any time.
- The application must implement mechanisms for graceful degradation in case of service outages or failures.
- The application must ensure the accuracy and consistency of data across all transactions.
- Automated backups must be performed regularly to prevent data loss, with the ability to restore data in case of corruption or accidental deletion.
- The application must handle errors gracefully, providing informative error messages and guidance on how to resolve issues.

## 4. Performance Requirements
- The application must respond to user actions within 1 second for most operations.
- Appointment booking and data retrieval operations must be completed within 2 seconds.
- The application architecture must be designed to support future scalability, allowing for the addition of new features and handling increased user loads.

## 5. Usability Requirements
- The user interface must be intuitive and user-friendly.
- The application must provide consistent and clear navigation, with user-friendly prompts and feedback.
- The application must support multiple languages, allowing users to choose their preferred language for the interface.
- The application must handle locale-specific formats for dates, times, and addresses.

## 6. Maintainability and Support
- The application code must be well-documented and follow coding standards to ensure maintainability.
- Automated tests must be implemented to ensure code reliability and facilitate future updates.
- The application must support seamless updates, allowing users to receive new features and security patches without disrupting their experience.
- The application must provide a mechanism for rolling back updates in case of issues.


<link rel="stylesheet" href="/assets/css/style.scss">

<div class="sidebar">
    <ul>
        <li><a href="https://fpmi-tp2024.github.io/tpmp-gpd-lab10-hryakopluxi/index.html">Home</a></li>
        <li><a href="https://fpmi-tp2024.github.io/tpmp-gpd-lab10-hryakopluxi/assignment.html">Assignment</a></li>
        <li><a href="https://fpmi-tp2024.github.io/tpmp-gpd-lab10-hryakopluxi/interface.html">App interface</a></li>
        <li><a href="https://fpmi-tp2024.github.io/tpmp-gpd-lab10-hryakopluxi/presentation.html">Project presentation</a></li>
        <li><a href="https://fpmi-tp2024.github.io/tpmp-gpd-lab10-hryakopluxi/specification.html">Project specification</a></li>
        <li><a href="https://fpmi-tp2024.github.io/tpmp-gpd-lab10-hryakopluxi/database.html">Database scheme</a></li>
    </ul>
</div>
