#!/usr/bin/env node
import { simpleGit } from "simple-git";
class Project {
  #count = 0;
  #simpleGit;

  constructor() {
    this.#simpleGit = simpleGit({
      maxConcurrentProcesses: 1,
      config: ["user.name=Dazl User", "user.email=alissa.vrk@gmail.com"],
    })
      .env("GIT_DIR", ".project-git")
      .env("GIT_WORK_TREE", ".");
  }

  increase() {
    this.#count++;
  }

  async commitProject(message) {
    await this.#simpleGit.add(".");
    await this.#simpleGit.commit(message);
  }

  async status() {
    return await this.#simpleGit.status();
  }

  async push(remote = 'origin', branch = 'main') {
    return await this.#simpleGit.push(remote, branch);
  }

  get count() {
    return this.#count;
  }
}

// Public API for terminal usage
function init() {
  const project = new Project();

  console.log("🚀 Project initialized!");
  console.log(`Initial count: ${project.count}`);

  // Demonstrate the functionality
  project.increase();
  console.log(`Count after increase: ${project.count}`);

  project.increase();
  console.log(`Count after another increase: ${project.count}`);

  return project;
}

// Export for module usage
export { Project, init };
