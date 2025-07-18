# API Specification

## Project Overview
**Project Name**: [Project Name]
**Version**: 1.0.0
**Date**: [Date]
**Author**: [Author]

## API Information
**Base URL**: `https://api.example.com/v1`
**Protocol**: HTTPS
**Authentication**: Bearer Token (JWT)
**Content Type**: `application/json`

## Authentication

### Bearer Token Authentication
All API requests require a valid JWT token in the Authorization header:

```
Authorization: Bearer <jwt_token>
```

### Token Endpoints

#### POST /auth/login
**Description**: Authenticate user and receive access token

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600,
  "token_type": "Bearer"
}
```

#### POST /auth/refresh
**Description**: Refresh access token using refresh token

**Request:**
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 3600,
  "token_type": "Bearer"
}
```

## Error Handling

### Error Response Format
All error responses follow this structure:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      "field": "Additional error details"
    }
  },
  "timestamp": "2024-01-15T10:30:00Z",
  "request_id": "req_123456789"
}
```

### HTTP Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `409` - Conflict
- `422` - Unprocessable Entity
- `429` - Too Many Requests
- `500` - Internal Server Error

### Common Error Codes
- `INVALID_REQUEST` - Request validation failed
- `UNAUTHORIZED` - Invalid or missing authentication
- `FORBIDDEN` - Insufficient permissions
- `NOT_FOUND` - Resource not found
- `VALIDATION_ERROR` - Input validation failed
- `RATE_LIMIT_EXCEEDED` - Too many requests
- `INTERNAL_ERROR` - Server error

## Data Models

### User
```typescript
interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'user';
  created_at: string; // ISO 8601
  updated_at: string; // ISO 8601
  is_active: boolean;
}
```

### Resource
```typescript
interface Resource {
  id: string;
  name: string;
  description?: string;
  owner_id: string;
  created_at: string; // ISO 8601
  updated_at: string; // ISO 8601
  metadata: Record<string, any>;
}
```

## API Endpoints

### Users

#### GET /users
**Description**: Get list of users with pagination
**Authentication**: Required (admin role)

**Query Parameters:**
- `limit` (integer, optional): Number of items per page (default: 20, max: 100)
- `offset` (integer, optional): Number of items to skip (default: 0)
- `search` (string, optional): Search term for name/email
- `role` (string, optional): Filter by user role
- `is_active` (boolean, optional): Filter by active status

**Response (200):**
```json
{
  "data": [
    {
      "id": "user_123",
      "email": "user@example.com",
      "name": "John Doe",
      "role": "user",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z",
      "is_active": true
    }
  ],
  "pagination": {
    "total": 150,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

#### GET /users/{user_id}
**Description**: Get specific user by ID
**Authentication**: Required

**Path Parameters:**
- `user_id` (string, required): User identifier

**Response (200):**
```json
{
  "id": "user_123",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "user",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "is_active": true
}
```

#### POST /users
**Description**: Create new user
**Authentication**: Required (admin role)

**Request:**
```json
{
  "email": "newuser@example.com",
  "name": "Jane Smith",
  "role": "user",
  "password": "securePassword123"
}
```

**Response (201):**
```json
{
  "id": "user_456",
  "email": "newuser@example.com",
  "name": "Jane Smith",
  "role": "user",
  "created_at": "2024-01-15T10:35:00Z",
  "updated_at": "2024-01-15T10:35:00Z",
  "is_active": true
}
```

#### PUT /users/{user_id}
**Description**: Update user information
**Authentication**: Required (own profile or admin)

**Path Parameters:**
- `user_id` (string, required): User identifier

**Request:**
```json
{
  "name": "John Updated",
  "role": "admin"
}
```

**Response (200):**
```json
{
  "id": "user_123",
  "email": "user@example.com",
  "name": "John Updated",
  "role": "admin",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:40:00Z",
  "is_active": true
}
```

#### DELETE /users/{user_id}
**Description**: Deactivate user (soft delete)
**Authentication**: Required (admin role)

**Path Parameters:**
- `user_id` (string, required): User identifier

**Response (204):** No Content

### Resources

#### GET /resources
**Description**: Get list of resources with pagination
**Authentication**: Required

**Query Parameters:**
- `limit` (integer, optional): Number of items per page (default: 20, max: 100)
- `offset` (integer, optional): Number of items to skip (default: 0)
- `search` (string, optional): Search term for name/description
- `owner_id` (string, optional): Filter by owner

**Response (200):**
```json
{
  "data": [
    {
      "id": "res_123",
      "name": "Example Resource",
      "description": "A sample resource",
      "owner_id": "user_123",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z",
      "metadata": {
        "category": "example",
        "tags": ["sample", "demo"]
      }
    }
  ],
  "pagination": {
    "total": 50,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

#### GET /resources/{resource_id}
**Description**: Get specific resource by ID
**Authentication**: Required

**Path Parameters:**
- `resource_id` (string, required): Resource identifier

**Response (200):**
```json
{
  "id": "res_123",
  "name": "Example Resource",
  "description": "A sample resource",
  "owner_id": "user_123",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "metadata": {
    "category": "example",
    "tags": ["sample", "demo"]
  }
}
```

#### POST /resources
**Description**: Create new resource
**Authentication**: Required

**Request:**
```json
{
  "name": "New Resource",
  "description": "Description of the new resource",
  "metadata": {
    "category": "example",
    "priority": "high"
  }
}
```

**Response (201):**
```json
{
  "id": "res_456",
  "name": "New Resource",
  "description": "Description of the new resource",
  "owner_id": "user_123",
  "created_at": "2024-01-15T10:35:00Z",
  "updated_at": "2024-01-15T10:35:00Z",
  "metadata": {
    "category": "example",
    "priority": "high"
  }
}
```

#### PUT /resources/{resource_id}
**Description**: Update resource
**Authentication**: Required (owner or admin)

**Path Parameters:**
- `resource_id` (string, required): Resource identifier

**Request:**
```json
{
  "name": "Updated Resource",
  "description": "Updated description",
  "metadata": {
    "category": "updated",
    "priority": "medium"
  }
}
```

**Response (200):**
```json
{
  "id": "res_123",
  "name": "Updated Resource",
  "description": "Updated description",
  "owner_id": "user_123",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:40:00Z",
  "metadata": {
    "category": "updated",
    "priority": "medium"
  }
}
```

#### DELETE /resources/{resource_id}
**Description**: Delete resource
**Authentication**: Required (owner or admin)

**Path Parameters:**
- `resource_id` (string, required): Resource identifier

**Response (204):** No Content

## Rate Limiting

### Rate Limit Headers
All responses include rate limiting information:

```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1642248600
```

### Rate Limits by Endpoint
- **Authentication endpoints**: 5 requests per minute
- **GET endpoints**: 100 requests per minute
- **POST/PUT/DELETE endpoints**: 50 requests per minute

## Pagination

### Request Parameters
- `limit`: Items per page (1-100, default: 20)
- `offset`: Items to skip (default: 0)

### Response Format
```json
{
  "data": [...],
  "pagination": {
    "total": 150,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

## Webhooks

### Webhook Events
- `user.created`
- `user.updated` 
- `user.deleted`
- `resource.created`
- `resource.updated`
- `resource.deleted`

### Webhook Payload
```json
{
  "event": "user.created",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "id": "user_123",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

### Webhook Security
Webhooks are signed with HMAC-SHA256. Verify signatures using the `X-Webhook-Signature` header.

## Testing

### Test Endpoints
- **Base URL**: `https://api-staging.example.com/v1`
- **Test Users**: Available in staging environment
- **Mock Data**: Predictable test data for integration testing

### Postman Collection
[Link to Postman collection for API testing]

## SDK and Client Libraries

### Official SDKs
- **JavaScript/TypeScript**: `@example/api-client`
- **Python**: `example-api-python`
- **Go**: `github.com/example/api-go`

### Code Examples

#### JavaScript
```javascript
import { ApiClient } from '@example/api-client';

const client = new ApiClient({
  baseUrl: 'https://api.example.com/v1',
  token: 'your-jwt-token'
});

const users = await client.users.list({ limit: 10 });
```

#### Python
```python
from example_api import ApiClient

client = ApiClient(
    base_url='https://api.example.com/v1',
    token='your-jwt-token'
)

users = client.users.list(limit=10)
```

---
*This specification should be kept in sync with the actual API implementation.*