import { runCode, submitCode, ApiError } from "./api";
import { SubmissionResult } from "./types";

export async function runSubmission(
  code: string,
  problemSlug: string
): Promise<SubmissionResult> {
  try {
    return await runCode({ problemSlug, language: "systemverilog", code });
  } catch (err) {
    if (err instanceof ApiError) {
      return {
        status: "error",
        compilationMessage: err.message,
        tests: [],
        score: 0,
        testsPassed: 0,
        testsTotal: 0,
        executionTime: 0,
        xpEarned: 0,
        xpTotal: 0,
        level: 1,
        progressStatus: null,
        achievementsUnlocked: [],
      };
    }
    return {
      status: "error",
      compilationMessage: "Unable to connect to the HDLForge server.",
      tests: [],
      score: 0,
      testsPassed: 0,
      testsTotal: 0,
      executionTime: 0,
      xpEarned: 0,
      xpTotal: 0,
      level: 1,
      progressStatus: null,
      achievementsUnlocked: [],
    };
  }
}

export async function submitSolution(
  code: string,
  problemSlug: string
): Promise<SubmissionResult> {
  try {
    return await submitCode({ problemSlug, language: "systemverilog", code });
  } catch (err) {
    if (err instanceof ApiError) {
      return {
        status: "error",
        compilationMessage: err.message,
        tests: [],
        score: 0,
        testsPassed: 0,
        testsTotal: 0,
        executionTime: 0,
        xpEarned: 0,
        xpTotal: 0,
        level: 1,
        progressStatus: null,
        achievementsUnlocked: [],
      };
    }
    return {
      status: "error",
      compilationMessage: "Unable to connect to the HDLForge server.",
      tests: [],
      score: 0,
      testsPassed: 0,
      testsTotal: 0,
      executionTime: 0,
      xpEarned: 0,
      xpTotal: 0,
      level: 1,
      progressStatus: null,
      achievementsUnlocked: [],
    };
  }
}
