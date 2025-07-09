# Studidi LMS

Studidi is a Learning Management System (LMS) built with Ruby on Rails 8. It provides a platform for teachers to create and manage courses, invite students, and organize course content into modules and lessons. Students can enroll in public courses, access course materials, and track their learning progress.

This project is part of our internship focused on Ruby on Rails development.

## Features

- **User Authentication:** Secure sign up, login, and password recovery using Devise.
- **Roles:** Users can be either students or teachers.
- **Course Management:** Teachers can create, edit, and delete courses.
- **Course Modules & Lessons:** Organize course content into modules and lessons (text or video).
- **Enrollments:** Students can enroll in or leave public courses.
- **Invitations:** Teachers can invite students to join private courses via email.
- **Email Notifications:** Invitation and confirmation emails sent via ActionMailer.
- **Pagination:** Courses, modules, and lessons are paginated for easy navigation.
- **Responsive UI:** Simple, clean interface for both teachers and students.

## Future Improvements

- Implement quizzes and assignments.
- Add progress tracking and analytics for students.
- Improve UI/UX with a modern design framework.
- Implement notifications.
- Enhance access control and permissions for more granular roles.

## Getting Started

### Prerequisites

- Ruby 3.2.8
- Rails 8.0.2
- PostgreSQL
- Bundler

### Setup Instructions

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/studidi.git
   cd studidi
   ```

2. **Install dependencies:**

    ```sh
    bundle install
    ```

3. **Database setup:**

    ```sh
    rails db:setup
    ```

4. **Configure ActionMailer for development:**

    Edit `config/environments/development.rb` and set your SMTP credentials:

    ```ruby
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              "smtp.gmail.com",
      port:                 587,
      domain:               "gmail.com",
      user_name:            "your_email@gmail.com",
      password:             "your_password",
      authentication:       "plain",
      enable_starttls_auto: true
    }
    config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
    ```

> **Note:** For Gmail, you may need to enable "Less secure app access" or use an App Password.

5. **Run the Rails server:**

    ```sh
    rails server
    ```

6. **Access the app:**

    Open [http://localhost:3000](http://localhost:3000) in your browser.
