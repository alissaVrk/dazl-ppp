we create a project with 2 git dirs:

1. for dazl, ignoring the normal .gitignore and basically committing all files
2. for user project using .project-git and normal .gitignore + .dazl/.gitignore.project to ignore dazl files and folders.

so when working on template we use regular git commands

and when user commits it should use special git-dir.

when we create a new project, we probably don't want any history for the user project.
so the template doesn't need to be a dual repo.
we can init the user project git repo after clone.

caveats:

1. pushing ignored stuff, like .env - by force add

   - we can just force add a list of files
   - we can can ls-files that are ignored and compare

2. if we ever want to use branches for the user project, it's going to be a mess.
   the issue is with trying to branch them both.. to preserve the right history for the user and the right AI summery.
   creating the branches is easy, can't merge them though

- not sure if merging the AI summery is realistic.
  - branching only the user project shouldn't be an issue.
- if we do want to branch the dazl project, merging .project.git sounds impossible.
  - we can push the project somewhere, and ignore it for dazl, so pull from 2 different locations... we can think about it if/when time comes I guess

3. if user wants to use his own remote, and can change the project at his free time without the editor.. then what?

   - I think it means that each project commit should be commit + push.
     so that, if there are conflicts at that point we resolve them (send the user to resolve)
     - this would mean that each commit means a pull.. that will be not

   * we clone dazl
   * we have uncommitted project changes
   * I'd say we stash, then pull, then apply. both of these could have conflicts..

   - lets say we pulled, now we want to update dazl

it seems there is no good way to skip saving the project git history in dazl with this design.
if we push both and duplicate the project files between them we can't resolve conflicts

if we don't duplicate but push separately including uncommitted, we have a branches issue

1. we need to track per commit
