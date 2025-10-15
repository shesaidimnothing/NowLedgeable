#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${2}${1}${NC}"
}

print_status "🎯 Nowledgeable - Quick Project Check" $PURPLE
print_status "====================================" $PURPLE
echo

BASE_DIR="/Users/w999/Desktop/nowledgeable"
cd "$BASE_DIR"

sessions=(
    "session-2-express-get:express_get_basics.js:3000"
    "session-3-express-post:express_post_basics.js:3001"
    "session-4-database-connection:express_with_db.js:3002"
    "session-5-middleware-static:express_middleware.js:3003"
    "session-6-auth-authorization:express_auth.js:3005"
)

passed=0
total=0

for session_info in "${sessions[@]}"; do
    IFS=':' read -r session_dir script_name port <<< "$session_info"
    
    print_status "📚 Checking $session_dir..." $BLUE
    
    if [ -d "$session_dir" ]; then
        print_status "✅ Directory exists" $GREEN
        
        if [ -f "$session_dir/$script_name" ]; then
            print_status "✅ Main script exists" $GREEN
            
            if [ -f "$session_dir/package.json" ]; then
                print_status "✅ Package.json exists" $GREEN
                
                if [ -d "$session_dir/node_modules" ] || [ -d "node_modules" ]; then
                    print_status "✅ Dependencies available" $GREEN
                    print_status "✅ $session_dir: READY TO RUN" $GREEN
                    ((passed++))
                else
                    print_status "⚠️  No node_modules found" $YELLOW
                fi
            else
                print_status "❌ Package.json missing" $RED
            fi
        else
            print_status "❌ Main script missing: $script_name" $RED
        fi
    else
        print_status "❌ Directory missing: $session_dir" $RED
    fi
    ((total++))
    echo
done

# Summary
print_status "📊 Project Status Summary" $PURPLE
print_status "========================" $PURPLE
print_status "Total Sessions: $total" $CYAN
print_status "Ready: $passed" $GREEN
print_status "Issues: $((total - passed))" $RED

if [ $passed -eq $total ]; then
    print_status "🎉 All sessions are ready to run!" $GREEN
else
    print_status "⚠️  Some sessions need attention." $YELLOW
fi

echo
print_status "🚀 How to run individual sessions:" $YELLOW
print_status "cd session-X-name && node script_name.js" $NC
echo
print_status "📋 Available sessions:" $CYAN
print_status "• Session 2: cd session-2-express-get && node express_get_basics.js" $NC
print_status "• Session 3: cd session-3-express-post && node express_post_basics.js" $NC
print_status "• Session 4: cd session-4-database-connection && node express_with_db.js" $NC
print_status "• Session 5: cd session-5-middleware-static && node express_middleware.js" $NC
print_status "• Session 6: cd session-6-auth-authorization && node express_auth.js" $NC
