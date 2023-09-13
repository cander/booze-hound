#!/bin/sh
#
# Run the rails application with Docker
#

IMAGE_TAG="boozehound/dev"
# Make sure we're in the root of the repo rather than this directory
if [ -f ../Gemfile ] ; then
    cd ..
fi

case "$1" in
    build)
        echo "Rebuild the Docker image..."
        now=`date`
        docker build -t $IMAGE_TAG -f docker-dev/Dockerfile --build-arg BUNDLE_DATE="$now" .
        ;;
    loaddb)
        echo "Load the development database with data from db/data.yml"
        if [ -f db/development.sqlite3 ] ; then
            echo "Backing up existing DB to /tmp"
            cp db/development.sqlite3 /tmp
        fi
        echo "Running db:data:load..."
        docker run -it --rm -v $(pwd):/rails $IMAGE_TAG bin/rake db:data:load
        ;;
    run)
        echo "Running Rails app on port 3000. Use ctl-C to exit"
        echo "Wait until you see the message, 'Listening on http://0.0.0.0:3000'"
        echo "Then you can go to:"
        echo ""
        echo "     http://localhost:3000"
        docker run -it --rm -v $(pwd):/rails -p 3000:3000 $IMAGE_TAG
        ;;
    *)
        echo "Usage: $0 [build|run]"
        echo "     build: Rebuild the Docker image with the latest dependencies"
        echo "    loaddb: Load the database with initial data"
        echo "       run:   Run the Rails app"
        ;;
esac
