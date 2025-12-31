const {
  baseRoot,
  getTask,
  createTask,
  updateTask,
  deleteTask,
} = require("../controllers/todoController");
const Todo = require("../models/todoModel");

// Mock the Todo model
jest.mock("../models/todoModel");

describe("Todo Controller", () => {
  let req, res;

  beforeEach(() => {
    req = {
      body: {},
      params: {},
    };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
      send: jest.fn().mockReturnThis(),
    };
    jest.clearAllMocks();
  });

  describe("baseRoot", () => {
    it("should return welcome message", () => {
      baseRoot(req, res);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.send).toHaveBeenCalled();
    });
  });

  describe("getTask", () => {
    it("should return all tasks successfully", async () => {
      const mockTasks = [
        { _id: "1", task: "Test task 1", isCompleted: false },
        { _id: "2", task: "Test task 2", isCompleted: true },
      ];

      Todo.find.mockResolvedValue(mockTasks);

      await getTask(req, res);

      expect(Todo.find).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(mockTasks);
    });

    it("should handle errors", async () => {
      const error = new Error("Database error");
      Todo.find.mockRejectedValue(error);

      await getTask(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Database error",
      });
    });
  });

  describe("createTask", () => {
    it("should create a task successfully", async () => {
      req.body = { task: "New task" };
      const mockTask = { _id: "1", task: "New task", isCompleted: false };

      Todo.create.mockResolvedValue(mockTask);

      await createTask(req, res);

      expect(Todo.create).toHaveBeenCalledWith({ task: "New task" });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith({
        message: "Task created successfully.",
        newList: mockTask,
      });
    });

    it("should return 400 if task is missing", async () => {
      req.body = {};

      await createTask(req, res);

      expect(Todo.create).not.toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Task is not valid.",
      });
    });

    it("should return 400 if task is not a string", async () => {
      req.body = { task: 123 };

      await createTask(req, res);

      expect(Todo.create).not.toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Task is not valid.",
      });
    });

    it("should handle creation errors", async () => {
      req.body = { task: "New task" };
      const error = new Error("Creation failed");
      Todo.create.mockRejectedValue(error);

      await createTask(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Creation failed",
      });
    });
  });

  describe("updateTask", () => {
    it("should update a task successfully", async () => {
      req.params.id = "1";
      req.body = { task: "Updated task" };
      const mockUpdatedTask = {
        _id: "1",
        task: "Updated task",
        isCompleted: false,
      };

      Todo.findByIdAndUpdate.mockResolvedValue(mockUpdatedTask);

      await updateTask(req, res);

      expect(Todo.findByIdAndUpdate).toHaveBeenCalledWith(
        "1",
        { task: "Updated task" },
        { new: true, runValidators: true }
      );
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith({
        message: "Task updated successfully.",
        updated: mockUpdatedTask,
      });
    });

    it("should return 404 if task not found", async () => {
      req.params.id = "nonexistent";
      req.body = { task: "Updated task" };

      Todo.findByIdAndUpdate.mockResolvedValue(null);

      await updateTask(req, res);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Task not found.",
      });
    });

    it("should handle update errors", async () => {
      req.params.id = "1";
      req.body = { task: "Updated task" };
      const error = new Error("Update failed");
      Todo.findByIdAndUpdate.mockRejectedValue(error);

      await updateTask(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Update failed",
      });
    });
  });

  describe("deleteTask", () => {
    it("should delete a task successfully", async () => {
      req.params.id = "1";
      const mockDeletedTask = { _id: "1", task: "Task to delete" };

      Todo.findByIdAndDelete.mockResolvedValue(mockDeletedTask);

      await deleteTask(req, res);

      expect(Todo.findByIdAndDelete).toHaveBeenCalledWith("1");
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith({
        message: "Task deleted successfully.",
        deleted: mockDeletedTask,
      });
    });

    it("should return 404 if task not found", async () => {
      req.params.id = "nonexistent";

      Todo.findByIdAndDelete.mockResolvedValue(null);

      await deleteTask(req, res);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Task not found.",
      });
    });

    it("should handle delete errors", async () => {
      req.params.id = "1";
      const error = new Error("Delete failed");
      Todo.findByIdAndDelete.mockRejectedValue(error);

      await deleteTask(req, res);

      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        errorMessage: "Delete failed",
      });
    });
  });
});

