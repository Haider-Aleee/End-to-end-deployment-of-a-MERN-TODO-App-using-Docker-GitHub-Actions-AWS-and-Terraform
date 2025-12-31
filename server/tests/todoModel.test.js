const mongoose = require("mongoose");
const Todo = require("../models/todoModel");

describe("Todo Model", () => {
  it("should have correct schema structure", () => {
    const schema = Todo.schema.obj;

    expect(schema.task).toBeDefined();
    expect(schema.task.type).toBe(String);
    expect(schema.task.required).toBe(true);

    expect(schema.isCompleted).toBeDefined();
    expect(schema.isCompleted.type).toBe(Boolean);
    expect(schema.isCompleted.default).toBe(false);
  });

  it("should create a todo instance with required fields", () => {
    const todoData = {
      task: "Test task",
    };

    const todo = new Todo(todoData);

    expect(todo.task).toBe("Test task");
    expect(todo.isCompleted).toBe(false);
  });

  it("should allow setting isCompleted to true", () => {
    const todo = new Todo({
      task: "Completed task",
      isCompleted: true,
    });

    expect(todo.isCompleted).toBe(true);
  });

  it("should have timestamps enabled", () => {
    const schemaOptions = Todo.schema.options;
    expect(schemaOptions.timestamps).toBeTruthy();
  });
});

