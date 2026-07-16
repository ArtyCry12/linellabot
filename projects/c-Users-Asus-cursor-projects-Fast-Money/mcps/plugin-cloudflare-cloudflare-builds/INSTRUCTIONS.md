# Cloudflare Workers Builds Tool
* A Cloudflare Worker is a serverless function
* Workers Builds is a CI/CD system for building and deploying your Worker whenever you push code to GitHub/GitLab.

This server allows you to view and debug Cloudflare Workers Builds for your Workers (NOT Cloudflare Pages).

To get started, you can list your Workers (workers_list) and set an active Worker (workers_builds_set_active_worker).
You can then list the builds for your Worker (workers_builds_list_builds) and set an active build (workers_builds_set_active_build).
Once you have an active build, you can view the logs (workers_builds_get_build_logs).