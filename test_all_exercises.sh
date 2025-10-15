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

print_status "🎯 Testing All Exercises - Nowledgeable Backend Course" $PURPLE
print_status "=====================================================" $PURPLE
echo

# Function to test a session
test_session() {
    local session_name="$1"
    local port="$2"
    local script_name="$3"
    local session_dir="$4"
    local tests=("${@:5}")
    
    print_status "🧪 Testing $session_name..." $CYAN
    
    # Change to session directory
    cd "$BASE_DIR/$session_dir" || {
        print_status "❌ Failed to change to $session_dir" $RED
        return 1
    }
    
    # Start server in background
    node "$script_name" > "/tmp/${session_name// /_}.log" 2>&1 &
    local server_pid=$!
    
    # Wait for server to start
    sleep 3
    
    local passed_tests=0
    local total_tests=${#tests[@]}
    
    # Run each test
    for test in "${tests[@]}"; do
        IFS='|' read -r test_name test_url expected_content <<< "$test"
        
        print_status "  🔍 $test_name..." $YELLOW
        
        local response=$(curl -s "$test_url" 2>/dev/null)
        local http_code=$(curl -s -w "%{http_code}" "$test_url" 2>/dev/null | tail -c 3)
        
        if [ "$http_code" = "200" ]; then
            if [ -n "$expected_content" ] && [[ "$response" == *"$expected_content"* ]]; then
                print_status "    ✅ PASS" $GREEN
                ((passed_tests++))
            elif [ -z "$expected_content" ]; then
                print_status "    ✅ PASS (HTTP 200)" $GREEN
                ((passed_tests++))
            else
                print_status "    ⚠️  PARTIAL (HTTP 200 but content mismatch)" $YELLOW
            fi
        else
            print_status "    ❌ FAIL (HTTP $http_code)" $RED
        fi
    done
    
    # Kill the server
    kill $server_pid 2>/dev/null
    wait $server_pid 2>/dev/null
    
    # Session result
    if [ $passed_tests -eq $total_tests ]; then
        print_status "✅ $session_name: ALL TESTS PASSED ($passed_tests/$total_tests)" $GREEN
        return 0
    else
        print_status "⚠️  $session_name: PARTIAL ($passed_tests/$total_tests tests passed)" $YELLOW
        return 1
    fi
}

# Test results
passed_sessions=0
total_sessions=0

# Session 2: Express GET Requests
print_status "📚 Session 2: Express GET Requests" $BLUE
print_status "--------------------------------" $BLUE
if test_session "Session 2" 3000 "express_get_basics.js" "session-2-express-get" \
    "Basic Route|http://localhost:3000/|Hello World" \
    "HTML Route|http://localhost:3000/some-html|bonjour html" \
    "JSON Route|http://localhost:3000/some-json|age" \
    "URL Params|http://localhost:3000/get-user/123|ID de l'utilisateur" \
    "Query Params|http://localhost:3000/exo-query-string?age=25|âge de la personne"; then
    ((passed_sessions++))
fi
((total_sessions++))

# Session 3: Express POST Methods
print_status "📚 Session 3: Express POST Methods" $BLUE
print_status "--------------------------------" $BLUE
if test_session "Session 3" 3001 "express_post_basics.js" "session-3-express-post" \
    "Basic Route|http://localhost:3001/|Hello World" \
    "GET Tasks|http://localhost:3001/tasks|[]" \
    "POST Echo|http://localhost:3001/data|test" \
    "POST New Task|http://localhost:3001/new-task|title"; then
    ((passed_sessions++))
fi
((total_sessions++))

# Session 4: Database Connection
print_status "📚 Session 4: Database Connection" $BLUE
print_status "--------------------------------" $BLUE
if test_session "Session 4" 3002 "express_with_db.js" "session-4-database-connection" \
    "Health Check|http://localhost:3002/health|OK" \
    "Get Users|http://localhost:3002/users|[]"; then
    ((passed_sessions++))
fi
((total_sessions++))

# Session 5: Middleware & Static Files
print_status "📚 Session 5: Middleware & Static Files" $BLUE
print_status "------------------------------------" $BLUE
if test_session "Session 5" 3003 "express_middleware.js" "session-5-middleware-static" \
    "Basic Route|http://localhost:3003/|Hello World" \
    "Static HTML|http://localhost:3003/index.html|Hello" \
    "Static CSS|http://localhost:3003/style.css|color: red"; then
    ((passed_sessions++))
fi
((total_sessions++))

# Session 6: Authentication & Authorization
print_status "📚 Session 6: Authentication & Authorization" $BLUE
print_status "----------------------------------------" $BLUE
if test_session "Session 6" 3005 "express_auth.js" "session-6-auth-authorization" \
    "Public Route|http://localhost:3005/|Bienvenue" \
    "Public Route 2|http://localhost:3005/public|publique" \
    "Protected Route|http://localhost:3005/protected|Token d'autorisation requis" \
    "Auth Endpoint|http://localhost:3005/authenticate|Email et mot de passe requis"; then
    ((passed_sessions++))
fi
((total_sessions++))

# Summary
print_status "📊 Final Test Results" $PURPLE
print_status "====================" $PURPLE
print_status "Total Sessions: $total_sessions" $CYAN
print_status "Fully Working: $passed_sessions" $GREEN
print_status "Issues: $((total_sessions - passed_sessions))" $RED

if [ $passed_sessions -eq $total_sessions ]; then
    print_status "🎉 ALL EXERCISES ARE WORKING PERFECTLY!" $GREEN
    print_status "✨ Your Node.js backend course is complete and functional!" $GREEN
elif [ $passed_sessions -gt 0 ]; then
    print_status "⚠️  Most exercises are working. Check any issues above." $YELLOW
else
    print_status "❌ No exercises are working. Please check your setup." $RED
fi

echo
print_status "🚀 Individual Session Commands:" $YELLOW
print_status "Session 2: cd session-2-express-get && node express_get_basics.js" $NC
print_status "Session 3: cd session-3-express-post && node express_post_basics.js" $NC
print_status "Session 4: cd session-4-database-connection && node express_with_db.js" $NC
print_status "Session 5: cd session-5-middleware-static && node express_middleware.js" $NC
print_status "Session 6: cd session-6-auth-authorization && node express_auth.js" $NC
