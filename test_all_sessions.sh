#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
BASE_DIR="/Users/w999/Desktop/nowledgeable"
SERVERS=()
PIDS=()

# Function to print colored output
print_status() {
    echo -e "${2}${1}${NC}"
}

# Function to cleanup servers
cleanup() {
    print_status "\n🧹 Cleaning up servers..." $YELLOW
    for pid in "${PIDS[@]}"; do
        if kill -0 $pid 2>/dev/null; then
            kill $pid
        fi
    done
    sleep 2
    print_status "✅ Cleanup completed" $GREEN
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Function to test a server
test_server() {
    local session_name="$1"
    local port="$2"
    local test_url="$3"
    local expected_content="$4"
    
    print_status "🧪 Testing $session_name on port $port..." $CYAN
    
    # Wait a moment for server to start
    sleep 2
    
    # Test the server
    local response=$(curl -s -w "%{http_code}" "$test_url" 2>/dev/null)
    local http_code="${response: -3}"
    local body="${response%???}"
    
    if [ "$http_code" = "200" ]; then
        if [ -n "$expected_content" ] && [[ "$body" == *"$expected_content"* ]]; then
            print_status "✅ $session_name: PASS - Server responding correctly" $GREEN
            return 0
        elif [ -z "$expected_content" ]; then
            print_status "✅ $session_name: PASS - Server responding (HTTP $http_code)" $GREEN
            return 0
        else
            print_status "⚠️  $session_name: PARTIAL - Server responding but content doesn't match" $YELLOW
            return 1
        fi
    else
        print_status "❌ $session_name: FAIL - HTTP $http_code" $RED
        return 1
    fi
}

# Function to start a server
start_server() {
    local session_name="$1"
    local port="$2"
    local script_name="$3"
    local session_dir="$4"
    
    print_status "🚀 Starting $session_name..." $BLUE
    
    # Change to session directory and start server
    cd "$BASE_DIR/$session_dir" || {
        print_status "❌ Failed to change to $session_dir" $RED
        return 1
    }
    
    # Install dependencies if needed
    if [ ! -d "node_modules" ]; then
        print_status "📦 Installing dependencies for $session_name..." $YELLOW
        npm install --silent
    fi
    
    # Start server in background
    node "$script_name" > "/tmp/${session_name// /_}.log" 2>&1 &
    local pid=$!
    PIDS+=($pid)
    
    # Wait a moment for server to start
    sleep 3
    
    # Check if server is still running
    if kill -0 $pid 2>/dev/null; then
        print_status "✅ $session_name started (PID: $pid)" $GREEN
        return 0
    else
        print_status "❌ $session_name failed to start" $RED
        return 1
    fi
}

# Main test function
run_tests() {
    print_status "🎯 Nowledgeable - Backend Node.js Course Test Suite" $PURPLE
    print_status "=================================================" $PURPLE
    echo
    
    # Test results tracking
    local passed=0
    local total=0
    
    # Session 2: Express GET
    print_status "\n📚 Session 2: Express GET Requests" $BLUE
    print_status "--------------------------------" $BLUE
    if start_server "Session 2" 3000 "express_get_basics.js" "session-2-express-get"; then
        if test_server "Session 2" 3000 "http://localhost:3000/" "Hello World"; then
            ((passed++))
        fi
        ((total++))
    else
        ((total++))
    fi
    
    # Session 3: Express POST
    print_status "\n📚 Session 3: Express POST Methods" $BLUE
    print_status "--------------------------------" $BLUE
    if start_server "Session 3" 3001 "express_post_basics.js" "session-3-express-post"; then
        if test_server "Session 3" 3001 "http://localhost:3001/" "Hello World"; then
            ((passed++))
        fi
        ((total++))
    else
        ((total++))
    fi
    
    # Test POST endpoint for Session 3
    print_status "🧪 Testing POST /data endpoint..." $CYAN
    local post_response=$(curl -s -X POST http://localhost:3001/data \
        -H "Content-Type: application/json" \
        -d '{"test": "post_method"}' 2>/dev/null)
    
    if [[ "$post_response" == *"test"* ]] && [[ "$post_response" == *"post_method"* ]]; then
        print_status "✅ POST /data: PASS - Echo server working" $GREEN
    else
        print_status "❌ POST /data: FAIL - Echo server not working" $RED
    fi
    
    # Session 4: Database Connection
    print_status "\n📚 Session 4: Database Connection" $BLUE
    print_status "--------------------------------" $BLUE
    if start_server "Session 4" 3002 "express_with_db.js" "session-4-database-connection"; then
        if test_server "Session 4" 3002 "http://localhost:3002/health" "OK"; then
            ((passed++))
        fi
        ((total++))
    else
        ((total++))
    fi
    
    # Session 5: Middleware & Static Files
    print_status "\n📚 Session 5: Middleware & Static Files" $BLUE
    print_status "------------------------------------" $BLUE
    if start_server "Session 5" 3003 "express_middleware.js" "session-5-middleware-static"; then
        if test_server "Session 5" 3003 "http://localhost:3003/" "Hello World"; then
            ((passed++))
        fi
        ((total++))
    else
        ((total++))
    fi
    
    # Test static files for Session 5
    print_status "🧪 Testing static files..." $CYAN
    local static_response=$(curl -s http://localhost:3003/index.html 2>/dev/null)
    if [[ "$static_response" == *"Hello"* ]] && [[ "$static_response" == *"HTML"* ]]; then
        print_status "✅ Static files: PASS - HTML file served correctly" $GREEN
    else
        print_status "❌ Static files: FAIL - HTML file not served" $RED
    fi
    
    # Session 6: Authentication & Authorization
    print_status "\n📚 Session 6: Authentication & Authorization" $BLUE
    print_status "----------------------------------------" $BLUE
    if start_server "Session 6" 3005 "express_auth.js" "session-6-auth-authorization"; then
        if test_server "Session 6" 3005 "http://localhost:3005/" "Bienvenue"; then
            ((passed++))
        fi
        ((total++))
    else
        ((total++))
    fi
    
    # Test authentication for Session 6
    print_status "🧪 Testing authentication..." $CYAN
    local auth_response=$(curl -s -X POST http://localhost:3005/authenticate \
        -H "Content-Type: application/json" \
        -d '{"email": "admin@test.com", "password": "admin123"}' 2>/dev/null)
    
    if [[ "$auth_response" == *"token"* ]] && [[ "$auth_response" == *"admin"* ]]; then
        print_status "✅ Authentication: PASS - Login working" $GREEN
    else
        print_status "❌ Authentication: FAIL - Login not working" $RED
    fi
    
    # Summary
    print_status "\n📊 Test Results Summary" $PURPLE
    print_status "=====================" $PURPLE
    print_status "Total Sessions: $total" $CYAN
    print_status "Passed: $passed" $GREEN
    print_status "Failed: $((total - passed))" $RED
    
    if [ $passed -eq $total ]; then
        print_status "\n🎉 All sessions are working perfectly!" $GREEN
        print_status "✨ Your Node.js backend course is complete!" $GREEN
    elif [ $passed -gt 0 ]; then
        print_status "\n⚠️  Some sessions need attention. Check the logs above." $YELLOW
    else
        print_status "\n❌ No sessions are working. Please check your setup." $RED
    fi
    
    print_status "\n📋 Session Details:" $CYAN
    print_status "• Session 2: Express GET requests (port 3000)" $NC
    print_status "• Session 3: Express POST methods (port 3001)" $NC
    print_status "• Session 4: Database connection (port 3002)" $NC
    print_status "• Session 5: Middleware & static files (port 3003)" $NC
    print_status "• Session 6: Authentication & authorization (port 3005)" $NC
}

# Check if we're in the right directory
if [ ! -f "README.md" ] || [ ! -d "session-2-express-get" ]; then
    print_status "❌ Please run this script from the nowledgeable project root directory" $RED
    exit 1
fi

# Run the tests
run_tests

# Cleanup will be called by trap
