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

# Use Case Diagram

<img width="525" alt="Снимок экрана 2024-05-30 в 16 00 30" src="https://github.com/fpmi-tp2024/tpmp-gpd-lab10-hryakopluxi/assets/60287872/7144e873-4e4c-4351-9cfd-f3455d756ee0">

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
