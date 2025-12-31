const request = require("supertest");
const express = require("express");
const todoRoutes = require("../routes/todoRoutes");

// Mock the controllers
jest.mock("../controllers/todoController", () => ({
  baseRoot: jest.fn((req, res) => res.status(200).json({ message: "Welcome" })),
  getTask: jest.fn((req, res) => res.status(200).json([])),
  createTask: jest.fn((req, res) =>
    res.status(201).json({ message: "Created" })
  ),
  updateTask: jest.fn((req, res) =>
    res.status(200).json({ message: "Updated" })
  ),
  deleteTask: jest.fn((req, res) =>
    res.status(200).json({ message: "Deleted" })
  ),
}));

const app = express();
app.use(express.json());
app.use("/api", todoRoutes);

describe("Todo Routes", () => {
  describe("GET /api/get", () => {
    it("should call getTask controller", async () => {
      const response = await request(app).get("/api/get");

      expect(response.status).toBe(200);
    });
  });

  describe("POST /api/new", () => {
    it("should call createTask controller", async () => {
      const response = await request(app)
        .post("/api/new")
        .send({ task: "Test task" });

      expect(response.status).toBe(201);
    });
  });

  describe("PUT /api/update/:id", () => {
    it("should call updateTask controller with id parameter", async () => {
      const response = await request(app)
        .put("/api/update/123")
        .send({ task: "Updated task" });

      expect(response.status).toBe(200);
    });
  });

  describe("DELETE /api/delete/:id", () => {
    it("should call deleteTask controller with id parameter", async () => {
      const response = await request(app).delete("/api/delete/123");

      expect(response.status).toBe(200);
    });
  });
});

