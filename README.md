# 🌐 My First Metaverse

A beginner-friendly 3D metaverse scene built with [Three.js](https://threejs.org/), featuring basic shapes, camera movement, and keyboard controls — all rendered in your browser.

---

## 📁 Project Structure

```
my-first-metaverse/
├── index.html
├── src/
│   ├── index.js
│   └── movements.js
```

---

## 🚀 Getting Started (Ubuntu/Linux)

### 1. Clone or Download the Repository

```bash
git clone https://github.com/yourusername/my-first-metaverse.git
cd my-first-metaverse
```

### 2. Serve the Project

Use Python's built-in HTTP server:

```bash
python3 -m http.server 5500
```

### 3. Open in Browser

Navigate to:

```
http://localhost:5500
```

> Make sure your `index.html` is in the project root and includes this line to load your JavaScript:

```html
<script type="module" src="./src/index.js"></script>
```

---

## 🎮 Controls

Use arrow keys to move the camera:

- ⬅️ Left: `←`
- ➡️ Right: `→`
- ⬆️ Up: Moves up and forward
- ⬇️ Down: Moves down and backward

---

## ✨ Features

- Basic 3D objects: Cube, Cone, Cylinder, Flat ground
- Scene lighting (ambient + directional)
- Smooth animations
- Real-time camera movement using keyboard

---

## 🧱 Built With

- [Three.js](https://threejs.org/) - 3D rendering engine
- JavaScript ES Modules
- HTML5
- Python HTTP server (`python3 -m http.server`)

---

## 🛠️ Troubleshooting

- **`404` on `movements.js`**  
  Ensure your import in `index.js` includes the `.js` extension:

  ```js
  import Movements from './movements.js';
  ```

- **Still not working?**  
  Use `Ctrl+Shift+R` to hard refresh and clear browser cache.

---

## 📌 Notes

- Designed to run entirely locally without a build tool (like Webpack or Vite).
- Ideal for learning Three.js basics.