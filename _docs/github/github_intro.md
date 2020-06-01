---
title: Github Notes
permalink: /docs/github_intro/
---

### creating a github repo from the command line

For all this you need to have a github account with username and password

the process of creating a git project from commandline takes the following process
create  a folder ,enter into it create a github project with the same name as the folder from the command line,
set the origin of the repository 

add files and folder into the project commit them and upload it to the server
#### Easiest way 
```
curl -u "anssshu" https://api.github.com/user/repos -d '{"name":"foo"}'
git clone https:github.com/anssshu/foo.git
cd foo
touch README.md 
git add .
git commit -m "msg"
git push origin master

```
### Other Ways
#### Create a folder

`mkdir foo`

#### Cd into the folder

`cd foo`

#### Create a github repo from the commandline

`curl -u  "anssshu" https://api.github.com/user/repos -d '{"name":"foo"}'`

#### set the origin of the github project



####  …or create a new repository on the command line
`echo "# foo" >> README.md`
`git init`
`git add README.md`
`git commit -m "first commit"`
`git remote add origin https://github.com/anssshu/foo.git`
`git push -u origin master`


####  …or push an existing repository from the command line
`git remote add origin https://github.com/anssshu/foo.git`
`git push -u origin master`
