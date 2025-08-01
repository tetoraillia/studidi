# Studidi LMS

Studidi is a comprehensive Learning Management System (LMS) built with Ruby on Rails 8. It provides a robust platform for educators to create and manage courses, organize content into structured modules and lessons, and facilitate student learning through interactive features. The system supports both public and private courses, real-time notifications, progress tracking, and comprehensive analytics.

## Features

### Core Functionality
- **User Authentication & Authorization**: Secure authentication using Devise with Google OAuth2 integration
- **Role-Based Access Control**: Distinct roles for students and teachers with appropriate permissions using Pundit
- **Course Management**: Complete CRUD operations for courses with public/private visibility settings
- **Modular Content Organization**: Structure courses into modules and lessons with support for text and video content
- **Interactive Quizzes**: Built-in quiz system for student assessment and progress evaluation
- **File Upload Management**: Support for course materials and media using CarrierWave with image processing

### Student Features
- **Course Enrollment**: Self-enrollment in public courses and invitation-based enrollment for private courses
- **Progress Tracking**: Real-time progress monitoring and performance analytics
- **Bookmarking System**: Save and organize favorite courses and lessons
- **Responsive Learning Interface**: Mobile-friendly design for learning on any device

### Teacher Features
- **Student Invitation System**: Email-based invitations for private courses
- **Progress Analytics**: Comprehensive tracking of student performance and engagement
- **Content Management**: Rich content creation tools for lessons and quizzes
- **Grade Management**: Mark and evaluate student responses and quiz attempts

### Advanced Features
- **Real-Time Notifications**: ActionCable-powered live notifications using the Noticed gem
- **Background Job Processing**: Sidekiq integration for email delivery and heavy processing tasks
- **Search & Filtering**: Advanced search capabilities using Ransack
- **Pagination**: Efficient content pagination using Kaminari
- **Modern Frontend**: Vite-powered asset pipeline with React components

## Installation

### Prerequisites

Ensure you have the following installed on your system:

- **Ruby**: 3.2.8 or higher
- **Rails**: 8.0.2
- **PostgreSQL**: 12 or higher
- **Node.js**: 18 or higher
- **Redis**: For ActionCable and Sidekiq
- **Bundler**: Latest version

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/studidi.git
   cd studidi
   ```

2. **Install Ruby dependencies**:
   ```bash
   bundle install
   ```

3. **Install JavaScript dependencies**:
   ```bash
   npm install
   ```

4. **Configure environment variables**:
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials and other configuration
   ```

5. **Setup the database**:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

6. **Start the development servers**:
   ```bash
   # Start Rails server
   rails server
   
   # In another terminal, start Vite dev server
   bin/vite dev
   
   # In another terminal, start Sidekiq (optional for background jobs)
   bundle exec sidekiq
   ```

7. **Access the application**:
   Open [http://localhost:3000](http://localhost:3000) in your web browser

## Usage

### For Teachers

1. **Create an Account**: Sign up and your account will be automatically assigned the teacher role
2. **Create Courses**: Navigate to the dashboard and create new courses with descriptions and visibility settings
3. **Add Content**: Organize your course into modules and add lessons with text or video content
4. **Create Quizzes**: Add interactive quizzes to assess student understanding
5. **Manage Students**: Invite students to private courses or monitor enrollments in public courses
6. **Track Progress**: Use the analytics dashboard to monitor student progress and performance

### For Students

1. **Create an Account**: Sign up as a student to access course materials
2. **Browse Courses**: Explore available public courses or accept invitations to private courses
3. **Enroll in Courses**: Join courses that interest you and start learning
4. **Complete Lessons**: Work through course materials at your own pace
5. **Take Quizzes**: Test your knowledge with interactive quizzes
6. **Track Progress**: Monitor your learning progress and view your grades

### API Usage

The application provides RESTful APIs for course management and user interactions. Authentication is required for most endpoints.

## Tech Stack

### Backend
- **Ruby on Rails** 8.0.2 - Web application framework
- **PostgreSQL** - Primary database
- **Redis** - Caching and ActionCable adapter
- **Sidekiq** - Background job processing
- **Devise** - Authentication and user management
- **Pundit** - Authorization and policy management
- **Noticed** - Notification system
- **CarrierWave** - File upload handling
- **Kaminari** - Pagination
- **Ransack** - Search and filtering

### Frontend
- **Vite** - Modern build tool and asset pipeline
- **React** 19.1.0 - Interactive UI components
- **Turbo & Stimulus** - Hotwire for enhanced interactivity
- **ActionCable** - Real-time features via WebSockets
- **Bootstrap** - Responsive CSS framework

### Development & Testing
- **RSpec** - Testing framework
- **Factory Bot** - Test data generation
- **Capybara** - Integration testing
- **RuboCop** - Code style and quality
- **Brakeman** - Security vulnerability scanning
- **SimpleCov** - Code coverage analysis

### Deployment
- **Docker** - Containerization
- **Kamal** - Deployment automation
- **Thruster** - HTTP acceleration for Puma

## Contributing

We welcome contributions to improve Studidi LMS. Please follow these guidelines:

### Getting Started

1. **Fork the repository** and create your feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Follow the coding standards**:
   - Run RuboCop for Ruby code style: `bundle exec rubocop`
   - Write tests for new features using RSpec
   - Ensure all tests pass: `bundle exec rspec`

3. **Commit your changes** with clear, descriptive messages:
   ```bash
   git commit -m "Add feature: description of your changes"
   ```

4. **Push to your fork** and submit a pull request:
   ```bash
   git push origin feature/your-feature-name
   ```

### Code Quality Standards

- Write comprehensive tests for new features
- Follow Rails conventions and best practices
- Maintain code coverage above 80%
- Use meaningful commit messages
- Update documentation for new features

### Reporting Issues

When reporting bugs or requesting features:

1. Check existing issues to avoid duplicates
2. Provide detailed reproduction steps
3. Include relevant system information
4. Add screenshots or error logs when applicable

## License

This project is part of an educational internship program focused on Ruby on Rails development.

## Support

For questions, issues, or contributions, please open an issue on GitHub or contact the development team.
