#!/bin/sh
#
# Run the rails application with Docker
#

IMAGE_TAG="boozehound/dev"
# Make sure we're in the root of the repo rather than this directory
if [ -f ../Gemfile ] ; then
    cd ..
fi

function docker_run() {
    echo Running: docker run -it --rm -v $(pwd):/rails -p 3000:3000 $IMAGE_TAG $*
    docker run -it --rm -v $(pwd):/rails -p 3000:3000 $IMAGE_TAG $*
}

case "$1" in
    build)
        echo "Rebuild the Docker image..."
        now=`date`
        docker build -t $IMAGE_TAG -f docker-dev/Dockerfile --build-arg BUNDLE_DATE="$now" .
        ;;
    console)
        docker_run /bin/bash
        ;;
    loaddb)
        prepare_task=""
        echo "Load the development database with data from db/data.yml."
        if [ -f db/development.sqlite3 ] ; then
            echo "Backing up existing development DB to /tmp/."
            cp db/development.sqlite3 /tmp
            echo "Previous DB backed up to /tmp/."
            echo ""

            echo "Removing any remaining existing DB file."
            rm db/development.sqlite3
            echo ""
        fi
        
        echo "There is no existing development DB (or it has been removed)."
        echo "Create a new one before loading."
        prepare_task="db:prepare"
        
        echo "Running $prepare_task db:data:load..."
        docker_run bin/rake $prepare_task db:data:load

        # check for file cleanup
        if [[ `git status | grep "schema.rb"` ]]; then
            echo "db/schema.rb needs to be reset."
            git checkout HEAD -- db/schema.rb
            echo "db/schema.rb has been reset."
        fi
        ;;
    migratedb)
        docker_run bin/rake db:migrate
        ;;
    run)
        echo "Running Rails app on port 3000. Use ctl-C to exit."
        echo "Wait until you see the message, 'Listening on http://0.0.0.0:3000'"
        echo "Then you can go to:"
        echo ""
        echo "     http://localhost:3000"
        docker_run
        ;;
    *)
        echo "Usage: $0 [build|run]"
        echo "     build: Rebuild the Docker image with the latest dependencies"
        echo "   console: Open a bash shell running in the Docker container"
        echo "    loaddb: Load the database with initial data"
        echo " migratedb: Run database migrations to update the schema"
        echo "       run: Run the Rails app"
        ;;
esac
