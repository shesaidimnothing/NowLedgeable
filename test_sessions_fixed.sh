#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BASE_DIR="/Users/w999/Desktop/nowledgeable"

print_status() {
    echo -e "${2}${1}${NC}"
}

print_status "🎯 Nowledgeable - Backend Node.js Course Test Suite" $PURPLE
print_status "=================================================" $PURPLE
echo

# Function to test a simple server
test_session() {
    local session_name="$1"
    local port="$2"
    local script_name="$3"
    local session_dir="$4"
    local test_url="$5"
    local expected_content="$6"
    
    print_status "🧪 Testing $session_name..." $CYAN
    
    # Change to session directory
    cd "$BASE_DIR/$session_dir" || {
        print_status "❌ Failed to change to $session_dir" $RED
        return 1
    }
    
    # Install dependencies if needed (with timeout and error handling)
    if [ ! -d "node_modules" ]; then
        print_status "📦 Installing dependencies..." $YELLOW
        
        # Use a different npm cache directory to avoid permission issues
        export NPM_CONFIG_CACHE="/tmp/npm-cache-$(whoami)"
        mkdir -p "$NPM_CONFIG_CACHE"
        
        # Install with timeout and capture output
        if timeout 30 npm install --silent 2>/dev/null; then
            print_status "✅ Dependencies installed successfully" $GREEN
        else
            print_status "⚠️  Dependencies installation failed or timed out, trying to continue..." $YELLOW
            # Check if express is available in parent node_modules
            if [ -f "$BASE_DIR/node_modules/express/package.json" ]; then
                print_status "📦 Using parent node_modules..." $YELLOW
                ln -sf "$BASE_DIR/node_modules" node_modules 2>/dev/null || true
            fi
        fi
    fi
    
    # Start server in background
    node "$script_name" > "/tmp/${session_name// /_}.log" 2>&1 &
    local server_pid=$!
    
    # Wait for server to start
    sleep 3
    
    # Test the server
    local response=$(curl -s "$test_url" 2>/dev/null)
    local http_code=$(curl -s -w "%{http_code}" "$test_url" 2>/dev/null | tail -c 3)
    
    # Kill the server
    kill $server_pid 2>/dev/null
    wait $server_pid 2>/dev/null
    
    # Check results
    if [ "$http_code" = "200" ]; then
        if [ -n "$expected_content" ] && [[ "$response" == *"$expected_content"* ]]; then
            print_status "✅ $session_name: PASS" $GREEN
            return 0
        elif [ -z "$expected_content" ]; then
            print_status "✅ $session_name: PASS (HTTP 200)" $GREEN
            return 0
        else
            print_status "⚠️  $session_name: PARTIAL (HTTP 200 but content mismatch)" $YELLOW
            return 1
        fi
    else
        print_status "❌ $session_name: FAIL (HTTP $http_code)" $RED
        if [ -f "/tmp/${session_name// /_}.log" ]; then
            print_status "   Log: $(head -3 "/tmp/${session_name// /_}.log")" $YELLOW
        fi
        return 1
    fi
}

# Test results
passed=0
total=0

# Session 2: Express GET
print_status "📚 Session 2: Express GET Requests" $BLUE
if test_session "Session 2" 3000 "express_get_basics.js" "session-2-express-get" "http://localhost:3000/" "Hello World"; then
    ((passed++))
fi
((total++))

# Session 3: Express POST
print_status "📚 Session 3: Express POST Methods" $BLUE
if test_session "Session 3" 3001 "express_post_basics.js" "session-3-express-post" "http://localhost:3001/" "Hello World"; then
    ((passed++))
fi
((total++))

# Session 4: Database Connection
print_status "📚 Session 4: Database Connection" $BLUE
if test_session "Session 4" 3002 "express_with_db.js" "session-4-database-connection" "http://localhost:3002/health" "OK"; then
    ((passed++))
fi
((total++))

# Session 5: Middleware & Static Files
print_status "📚 Session 5: Middleware & Static Files" $BLUE
if test_session "Session 5" 3003 "express_middleware.js" "session-5-middleware-static" "http://localhost:3003/" "Hello World"; then
    ((passed++))
fi
((total++))

# Session 6: Authentication & Authorization
print_status "📚 Session 6: Authentication & Authorization" $BLUE
if test_session "Session 6" 3005 "express_auth.js" "session-6-auth-authorization" "http://localhost:3005/" "Bienvenue"; then
    ((passed++))
fi
((total++))

# Summary
print_status "📊 Test Results Summary" $PURPLE
print_status "=====================" $PURPLE
print_status "Total Sessions: $total" $CYAN
print_status "Passed: $passed" $GREEN
print_status "Failed: $((total - passed))" $RED

if [ $passed -eq $total ]; then
    print_status "🎉 All sessions are working perfectly!" $GREEN
    print_status "✨ Your Node.js backend course is complete!" $GREEN
elif [ $passed -gt 0 ]; then
    print_status "⚠️  Some sessions need attention. Check the logs above." $YELLOW
else
    print_status "❌ No sessions are working. Please check your setup." $RED
fi

print_status "📋 Session Details:" $CYAN
print_status "• Session 2: Express GET requests (port 3000)" $NC
print_status "• Session 3: Express POST methods (port 3001)" $NC
print_status "• Session 4: Database connection (port 3002)" $NC
print_status "• Session 5: Middleware & static files (port 3003)" $NC
print_status "• Session 6: Authentication & authorization (port 3005)" $NC

print_status "🚀 To run individual sessions:" $YELLOW
print_status "cd session-X-name && npm install && npm start" $NC
