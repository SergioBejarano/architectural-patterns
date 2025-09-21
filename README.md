# Property Manager

A Spring Boot web application for property management with CRUD operations through a modern web interface and REST API.

## Tech Stack

- **Java 17**
- **Spring Boot 3.3.7**
- **Spring Data JPA**
- **MySQL 8.0**
- **Docker & Docker Compose**
- **HTML5, CSS3, JavaScript**

## Quick Start

### Prerequisites

- Docker
- Docker Compose

### Run with Docker

1. **Clone repository**:

   ```bash
   git clone https://github.com/SergioBejarano/architectural-patterns.git
   cd architectural-patterns
   ```

2. **Start containers**:

   ```bash
   docker-compose up --build
   ```

3. **Access application**:

   - Frontend: http://localhost:9000
   - API: http://localhost:9000/api/properties

4. **Stop containers**:
   ```bash
   docker-compose down
   ```

## API Endpoints

| Method   | Endpoint               | Description        |
| -------- | ---------------------- | ------------------ |
| `GET`    | `/api/properties`      | Get all properties |
| `GET`    | `/api/properties/{id}` | Get property by ID |
| `POST`   | `/api/properties`      | Create property    |
| `PUT`    | `/api/properties/{id}` | Update property    |
| `DELETE` | `/api/properties/{id}` | Delete property    |

## Local Development

### Prerequisites

- Java 17+
- Maven 3.6+
- MySQL 8.0

### Port Conflicts

Change ports in `docker-compose.yml` if needed:

```yaml
ports:
  - "8080:9000" # App
  - "3307:3306" # MySQL
```

## Author

**Sergio Bejarano**
