module.exports = {
  extends: ["@commitlint/config-conventional"],
  ignores: [
    (message) => /^Initial plan$/i.test((message || "").trim())
  ],
  rules: {
    "type-enum": [
      2,
      "always",
      [
        "feat",
        "fix",
        "docs",
        "style",
        "refactor",
        "perf",
        "test",
        "build",
        "ci",
        "chore",
        "revert"
      ]
    ],
    "subject-case": [0]
  }
};
