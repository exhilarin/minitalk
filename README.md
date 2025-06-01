# 📡 minitalk

![42 Project](https://img.shields.io/badge/42%20Network-minitalk-blue?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-C-blue?style=for-the-badge)

## 📚 Project Summary

**minitalk** is a small client-server communication project in the 42 curriculum. The goal is to implement a simple data transfer program using UNIX signals (`SIGUSR1` and `SIGUSR2`). The client sends messages to the server by encoding characters bit by bit through signals. The server receives and decodes these signals to reconstruct the original message.

This project introduces inter-process communication (IPC), signal handling, bitwise operations, and synchronizing data transfer between processes in C.

---

## 🧠 What I Learned in minitalk

### 🔹 UNIX Signals and IPC
- Using `signal()` and `sigaction()` to handle signals asynchronously
- Sending signals between processes with `kill()`
- Synchronizing communication by sending acknowledgments

### 🔹 Bitwise Operations
- Encoding characters bit-by-bit using signals
- Shifting bits left and right to assemble characters from signals

### 🔹 Process IDs and Client-Server Model
- Managing server PID and passing it to the client
- Implementing basic client-server communication without sockets

### 🔹 Robust Communication
- Handling message length and end-of-transmission markers
- Ensuring reliability with signal acknowledgments

### 🔹 Memory Management and Clean Code
- Avoiding memory leaks during message construction
- Structuring the code modularly for readability and maintainability

### 🔹 Norminette Compliance
- Writing code adhering to 42’s coding standards

---

## 📁 Project Structure

```bash
minitalk/
├── client.c            # Client program sending messages
├── server.c            # Server program receiving messages
├── minitalk.h          # Header file
├── Makefile            # Build instructions
└── README.md           # Project documentation
