# Property Manager

A Spring Boot web application for property management with CRUD operations through a modern web interface and REST API. This application supports both local development with Docker Compose and AWS cloud deployment with separate EC2 instances.

## Tech Stack

- **Java 17**
- **Spring Boot 3.3.7**
- **Spring Data JPA**
- **MySQL 8.0**
- **Docker & Docker Compose**
- **HTML5, CSS3, JavaScript**
- **AWS EC2**
- **DockerHub**

## 🏠 Local Development Setup

### Prerequisites

- Docker
- Docker Compose
- Maven 3.6+
- Java 17+

### Step-by-Step Local Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/SergioBejarano/architectural-patterns.git
   cd architectural-patterns
   ```

2. **Compile the application:**

   ```bash
   mvn clean package -DskipTests
   ```

3. **Start the containers:**

   ```bash
   docker-compose up --build
   ```

<img width="2352" height="350" alt="image" src="https://github.com/user-attachments/assets/08a26b2e-b548-4c0b-a597-c50660d7a0c8" />


4. **Access the application:**

   - Frontend: http://localhost:9000
  
<img width="2877" height="1720" alt="image" src="https://github.com/user-attachments/assets/5e013845-b3d5-449e-94e7-1ffaa13daa02" />


   - API: http://localhost:9000/api/properties
<img width="2879" height="1704" alt="image" src="https://github.com/user-attachments/assets/2d131dee-5344-4a59-8a6a-793144c80f5b" />



5. **Stop the containers:**
   ```bash
   docker-compose down
   ```

## ☁️ AWS Cloud Deployment

### Architecture Overview

```
                            AWS CLOUD INFRASTRUCTURE
    ┌─────────────────────────────────────────────────────────────────────┐
    │                                                                     │
    │  ┌─────────────────────────┐         ┌─────────────────────────┐    │
    │  │     EC2 BACKEND         │         │     EC2 DATABASE        │    │
    │  │                         │         │                         │    │
    │  │  ┌─────────────────┐    │  TCP    │  ┌─────────────────┐    │    │
    │  │  │  Spring Boot    │    │  3306   │  │     MySQL       │    │    │
    │  │  │  Application    │────┼─────────┼──│   Database      │    │    │
    │  │  │                 │    │         │  │                 │    │    │
    │  │  │  Port: 9000     │    │         │  │  Port: 3306     │    │    │
    │  │  └─────────────────┘    │         │  └─────────────────┘    │    │
    │  │                         │         │                         │    │
    │  │ sergiobejarano/         │         │ sergiobejarano/         │    │
    │  │ properties-app:v1.1     │         │ properties-bd           │    │
    │  └─────────────────────────┘         └─────────────────────────┘    │
    │              │                                                      │
    └──────────────┼──────────────────────────────────────────────────────┘
                   │
                   │ HTTP:9000
                   │
    ┌──────────────▼──────────────┐
    │                             │
    │        INTERNET             │
    │      (End Users)            │
    │                             │
    └─────────────────────────────┘

    📊 COMPONENTS:
    • Backend EC2:  Spring Boot + REST API + Web Frontend
    • Database EC2: MySQL Database with persistent storage
    • Network:      Private communication + Public web access
```

### Prerequisites for AWS Deployment

- AWS Account
- EC2 Key Pair
- DockerHub Account
- Local Docker environment

### Step 1: Prepare Docker Images

1. **Build and push application image:**

   ```bash
   # Compile application
   mvn clean package -DskipTests

   # Build Docker image
   docker build -t sergiobejarano/properties-app:latest .

   # Create version tag
   docker tag sergiobejarano/properties-app:latest sergiobejarano/properties-app:v1.1

   # Push to DockerHub
   docker login
   docker push sergiobejarano/properties-app:latest
   docker push sergiobejarano/properties-app:v1.1
   ```

<img width="2879" height="1619" alt="image" src="https://github.com/user-attachments/assets/da4a6ccc-d5c4-48e7-9ed2-166fb38a3cdd" />


2. **Create database image from local container:**

   ```bash
   # Start local MySQL container
   docker-compose up -d mysql

   # Create image from running container
   docker commit propertymanager-mysql sergiobejarano/properties-bd:latest

   # Create production tag
   docker tag sergiobejarano/properties-bd:latest sergiobejarano/properties-bd:production

   # Push to DockerHub
   docker push sergiobejarano/properties-bd:latest
   docker push sergiobejarano/properties-bd:production
   ```

<img width="2879" height="1622" alt="image" src="https://github.com/user-attachments/assets/b78eb368-c9eb-47c0-a50b-91cf013a58cd" />



### Step 2: Create EC2 Database Instance

1. **Launch EC2 instance:**

   - AMI: Amazon Linux 2023
   - Instance Type: t2.micro
   - Name: `properties-bd`
   - Security Group: Allow SSH (22) and MySQL (3306)


2. **Connect and setup Docker:**

   ```bash
   # Connect to EC2
   ssh -i sergioBD.pem ec2-user@database-ec2-ip

   # Install Docker
   sudo yum update -y
   sudo yum install docker -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -a -G docker ec2-user

   # Logout and reconnect
   exit
   ssh -i sergioBD.pem ec2-user@database-ec2-ip
   ```

3. **Deploy MySQL database:**

   ```bash
   # Create data directory
   mkdir -p /home/ec2-user/mysql-data

   # Run MySQL container with your data
   docker run -d \
     --name propertymanager-mysql \
     --restart unless-stopped \
     -p 3306:3306 \
     -v /home/ec2-user/mysql-data:/var/lib/mysql \
     sergiobejarano/properties-bd:production

   # Verify deployment
   docker ps
   docker logs propertymanager-mysql
   ```

### Step 3: Create EC2 Backend Instance

1. **Launch EC2 instance:**

   - AMI: Amazon Linux 2023
   - Instance Type: t2.micro
   - Name: `properties-app`
   - Security Group: Allow SSH (22) and HTTP (9000)

<img width="2876" height="1550" alt="image" src="https://github.com/user-attachments/assets/dd1c3405-c2d3-494f-a803-e86ecec66e56" />


2. **Connect and setup Docker:**

   ```bash
   # Connect to EC2
   ssh -i sergio.pem ec2-user@backend-ec2-ip

   # Install Docker
   sudo yum update -y
   sudo yum install docker -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -a -G docker ec2-user

   # Logout and reconnect
   exit
   ssh -i sergio.pem ec2-user@backend-ec2-ip
   ```

3. **Deploy Spring Boot application:**

   ```bash
   # Run application container
   docker run -d \
     --name properties-app \
     --restart unless-stopped \
     -p 9000:9000 \
     -e SPRING_PROFILES_ACTIVE=aws-production \
     -e DB_HOST=database-ec2-private-ip \
     -e DB_PORT=3306 \
     -e DB_NAME=propertymanager \
     -e DB_USER=root \
     -e DB_PASSWORD=root \
     -e PORT=9000 \
     sergiobejarano/properties-app:latest

   # Verify deployment
   docker ps
   docker logs properties-app
   ```
<img width="1153" height="348" alt="image" src="https://github.com/user-attachments/assets/16a21a40-76f2-4496-aa58-e6ddda1542ef" />


### Step 4: Configure Security Groups

**Database EC2 Security Group:**

- Inbound: SSH (22) from your IP
- Inbound: MySQL (3306) from Backend Security Group
<img width="2380" height="452" alt="image" src="https://github.com/user-attachments/assets/c2b3c410-d6f3-4e25-b86b-9b3b3d96e352" />


**Backend EC2 Security Group:**

- Inbound: SSH (22) from your IP
- Inbound: Custom TCP (9000) from 0.0.0.0/0
<img width="2298" height="776" alt="image" src="https://github.com/user-attachments/assets/1fd2a41e-35fe-47b6-9dbe-e7ed5653d056" />



### Step 5: Access Deployed Application

- **Web Application:** `http://backend-ec2-public-ip:9000`
- **API Endpoints:** `http://backend-ec2-public-ip:9000/api/properties`

## 📚 API Documentation

| Method   | Endpoint               | Description        |
| -------- | ---------------------- | ------------------ |
| `GET`    | `/api/properties`      | Get all properties |
| `GET`    | `/api/properties/{id}` | Get property by ID |
| `POST`   | `/api/properties`      | Create property    |
| `PUT`    | `/api/properties/{id}` | Update property    |
| `DELETE` | `/api/properties/{id}` | Delete property    |

## 🔧 Troubleshooting

### Local Development Issues

- **Port conflicts:** Change ports in `docker-compose.yml`
- **Database connection:** Ensure MySQL container is running
- **Build issues:** Verify Java 17 and Maven are installed

### AWS Deployment Issues

- **Connection refused:** Check Security Groups and EC2 status
- **Database connection:** Verify private IP and Security Group rules
- **Cache issues:** Clear browser cache (Ctrl+F5)
- **Container logs:** Use `docker logs container-name` for debugging

## 🏷️ Docker Images

- **Application:** `sergiobejarano/properties-app:v1.1`
- **Database:** `sergiobejarano/properties-bd:production`

## 👤 Author

**Sergio Bejarano**

- GitHub: [@SergioBejarano](https://github.com/SergioBejarano)
- Repository: [architectural-patterns](https://github.com/SergioBejarano/architectural-patterns)
