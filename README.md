# HDLForge

A browser-based HDL (Hardware Description Language) practice platform built with Next.js and FastAPI.

## Architecture

```
            HDLForge
               |
      +--------+--------+
      |                 |
  Next.js            FastAPI
      |                 |
      |             PostgreSQL
      |
  Monaco Editor
      |
  Run / Submit
      |
      +---------------> API
                            |
                      Execution Engine
                            |
                      +-----+-----+
                      |           |
                   Docker     Direct
                   Sandbox    Execution
                      |           |
                      +-----+-----+
                            |
                      Verilator
                            |
                      Testbench
                            |
                      Result Parser
```

## Requirements

- **Python** 3.11+
- **Node.js** 18+
- **PostgreSQL** 14+
- **Verilator** (for direct execution mode)
- **Docker** (optional, for sandboxed execution)

## Quick Start

### 1. Database Setup

Create a PostgreSQL database:

```sql
CREATE DATABASE hdlforge;
CREATE USER hdlforge WITH PASSWORD 'hdlforge';
GRANT ALL PRIVILEGES ON DATABASE hdlforge TO hdlforge;
```

### 2. Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Copy environment file
cp .env.example .env

# Run migrations
alembic upgrade head

# Seed problems with testbenches
python -m app.seed

# Start the server
uvicorn app.main:app --reload
```

Backend runs at http://localhost:8000

API docs available at:
- http://localhost:8000/docs (Swagger UI)
- http://localhost:8000/redoc (ReDoc)

### 3. Frontend Setup

```bash
# From project root
npm install
npm run dev
```

Frontend runs at http://localhost:3000

### 4. HDL Execution Setup

**Option A: Direct Execution (Recommended for Development)**

Install Verilator:
- **Ubuntu/Debian**: `sudo apt-get install verilator`
- **macOS**: `brew install verilator`
- **Windows**: Use WSL2 or install from source

Set in `backend/.env`:
```
HDL_USE_DOCKER=false
```

**Option B: Docker Sandbox (Recommended for Production)**

```bash
cd docker/hdl-sandbox
docker build -t hdlforge-sandbox:latest .
```

Set in `backend/.env`:
```
HDL_USE_DOCKER=true
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/problems` | List problems (supports `difficulty`, `category`, `search` query params) |
| GET | `/api/problems/{slug}` | Get single problem by slug |
| POST | `/api/submissions/run` | Run code against problem testbench |
| POST | `/api/submissions/submit` | Submit solution for judging |

### Query Parameters for /api/problems

- `difficulty` - Filter by difficulty (EASY, MEDIUM, HARD)
- `category` - Filter by category
- `search` - Search in title and description

## Environment Variables

### Backend (.env)

```
POSTGRES_USER=hdlforge
POSTGRES_PASSWORD=hdlforge
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=hdlforge
DEBUG=true
CORS_ORIGINS=["http://localhost:3000"]

# HDL Execution
HDL_EXECUTION_TIMEOUT=5
HDL_MEMORY_LIMIT=256
HDL_CPU_LIMIT=5
HDL_PROCESS_LIMIT=64
HDL_MAX_SOURCE_SIZE=50000
HDL_MAX_OUTPUT_SIZE=100000
HDL_USE_DOCKER=false
```

### Frontend (.env.local)

```
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## HDL Execution Architecture

### How It Works

1. User writes SystemVerilog code in Monaco Editor
2. Frontend sends code to `POST /api/submissions/run`
3. Backend validates the submission
4. Execution Engine creates a temporary workspace
5. User code and problem testbench are written to workspace
6. Verilator compiles the code
7. Testbench simulation runs
8. Result Parser extracts structured test results
9. Response is sent back to frontend
10. Workspace is cleaned up

### Testbench Protocol

Testbenches emit structured markers for result parsing:

```systemverilog
$display("HDLFORGE_TEST_NAME:test name");
$display("HDLFORGE_TEST_PASS");  // or HDLFORGE_TEST_FAIL
$display("HDLFORGE_EXPECTED:expected value");
$display("HDLFORGE_RECEIVED:actual value");
$display("HDLFORGE_SCORE:100");
```

### Security

- User HDL is executed in an isolated environment
- Docker mode provides container isolation with:
  - No network access
  - Memory limits
  - CPU limits
  - Process limits
  - Read-only filesystem (except workspace)
- Direct mode uses subprocess isolation with timeout enforcement
- All temporary files are cleaned up after execution
- No user-controlled shell command execution

## Supported Problems

### Combinational Logic
- AND Gate
- OR Gate
- NOT Gate
- XOR Gate
- 2:1 Multiplexer

### Arithmetic
- Half Adder
- Full Adder

### Sequential Logic
- D Flip-Flop

### Medium Difficulty
- 4-bit Counter
- ALU (4-bit)

## Project Structure

```
HBL_Codemate/
+-- src/                    # Next.js frontend
|   +-- app/                # App Router pages
|   +-- components/         # React components
|   +-- lib/                # Utilities and API client
+-- backend/                # FastAPI backend
|   +-- app/
|   |   +-- api/routes/     # API route handlers
|   |   +-- core/           # Configuration
|   |   +-- db/             # Database models
|   |   +-- execution/      # HDL execution engine
|   |   +-- sandbox/        # Docker sandbox
|   |   +-- schemas/        # Pydantic schemas
|   |   +-- services/       # Business logic
|   |   +-- simulator/      # Verilator abstraction
|   |   +-- tests/          # Backend tests
|   +-- alembic/            # Database migrations
+-- docker/
    +-- hdl-sandbox/        # Docker image for HDL execution
```

## Testing

### Backend Tests

```bash
cd backend
pip install -r requirements.txt
pytest
```

### Frontend Build

```bash
npm run build
npm run lint
```

## Phase 3 Status

This phase implements:

- Real SystemVerilog execution via Verilator
- Docker sandbox for isolated execution
- Testbench protocol for structured results
- Result parsing for test outcomes
- Workspace management with cleanup
- Timeout and resource limits
- Compilation error reporting
- Runtime error detection

### Not Yet Implemented

- Hidden testbench system
- Authentication
- User accounts
- Leaderboards
- AI assistance
- Waveform visualization
