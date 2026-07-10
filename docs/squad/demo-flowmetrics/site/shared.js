/**
 * FlowMetrics v3 — cinematic 3D hero + scroll motion (huashu + Stitch/Figma symbiosis)
 */
(function () {
  const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const canvas = document.getElementById("hero-canvas");
  if (canvas && !reduced && window.THREE) initThree(canvas);

  document.querySelectorAll(".reveal").forEach((el) => {
    new IntersectionObserver(
      (entries) => entries.forEach((e) => e.isIntersecting && e.target.classList.add("visible")),
      { threshold: 0.12, rootMargin: "0px 0px -40px 0px" }
    ).observe(el);
  });

  const stage = document.querySelector(".hero-stage");
  const frame = document.querySelector(".hero-frame");
  if (!reduced && stage) {
    window.addEventListener(
      "scroll",
      () => {
        const y = window.scrollY;
        stage.style.transform = `translateY(${y * 0.12}px)`;
        stage.style.opacity = String(Math.max(0, 1 - y / 650));
      },
      { passive: true }
    );
    window.addEventListener("mousemove", (e) => {
      if (!frame) return;
      const x = (e.clientX / window.innerWidth - 0.5) * 12;
      const y = (e.clientY / window.innerHeight - 0.5) * 8;
      frame.style.transform = `perspective(1200px) rotateY(${-8 + x * 0.15}deg) rotateX(${4 - y * 0.1}deg)`;
    });
  }
})();

function initThree(canvas) {
  const THREE = window.THREE;
  const renderer = new THREE.WebGLRenderer({ canvas, alpha: true, antialias: true, powerPreference: "high-performance" });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(42, 1, 0.1, 100);
  camera.position.set(0, 0.3, 7);

  const group = new THREE.Group();
  scene.add(group);

  const crystalGeo = new THREE.IcosahedronGeometry(0.95, 2);
  const crystalMat = new THREE.MeshPhysicalMaterial({
    color: 0x0a84ff,
    metalness: 0.75,
    roughness: 0.08,
    transmission: 0.55,
    thickness: 1.5,
    emissive: 0x0a84ff,
    emissiveIntensity: 0.35,
    clearcoat: 1,
    clearcoatRoughness: 0.1,
  });
  const crystal = new THREE.Mesh(crystalGeo, crystalMat);
  group.add(crystal);

  const knotGeo = new THREE.TorusKnotGeometry(1.35, 0.08, 128, 24);
  const knotMat = new THREE.MeshBasicMaterial({
    color: 0xf59e0b,
    wireframe: true,
    transparent: true,
    opacity: 0.28,
  });
  const knot = new THREE.Mesh(knotGeo, knotMat);
  group.add(knot);

  const ringMat = new THREE.MeshBasicMaterial({ color: 0x5ac8fa, wireframe: true, transparent: true, opacity: 0.22 });
  const ring1 = new THREE.Mesh(new THREE.TorusGeometry(2.1, 0.025, 8, 80), ringMat);
  const ring2 = new THREE.Mesh(new THREE.TorusGeometry(2.55, 0.018, 8, 80), ringMat.clone());
  ring2.material.color.setHex(0x0a84ff);
  ring2.rotation.x = Math.PI / 2.8;
  group.add(ring1, ring2);

  const count = 600;
  const positions = new Float32Array(count * 3);
  for (let i = 0; i < count * 3; i++) positions[i] = (Math.random() - 0.5) * 14;
  const particles = new THREE.Points(
    new THREE.BufferGeometry().setAttribute("position", new THREE.BufferAttribute(positions, 3)),
    new THREE.PointsMaterial({ color: 0x5ac8fa, size: 0.035, transparent: true, opacity: 0.75, blending: THREE.AdditiveBlending })
  );
  scene.add(particles);

  scene.add(new THREE.AmbientLight(0x223366, 0.6));
  const key = new THREE.DirectionalLight(0xffffff, 1.4);
  key.position.set(4, 5, 6);
  scene.add(key);
  const rim = new THREE.PointLight(0xf59e0b, 1.2, 20);
  rim.position.set(-3, 2, 4);
  scene.add(rim);

  group.position.set(1.2, 0.2, 0);

  let mx = 0, my = 0;
  window.addEventListener("mousemove", (e) => {
    mx = (e.clientX / window.innerWidth - 0.5) * 2;
    my = (e.clientY / window.innerHeight - 0.5) * 2;
  });

  function resize() {
    const w = canvas.clientWidth;
    const h = canvas.clientHeight;
    renderer.setSize(w, h, false);
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }
  resize();
  window.addEventListener("resize", resize);

  let t = 0;
  function animate() {
    t += 0.007;
    crystal.rotation.x = t * 0.35 + my * 0.25;
    crystal.rotation.y = t * 0.55 + mx * 0.35;
    knot.rotation.x = t * 0.2;
    knot.rotation.y = t * 0.45;
    ring1.rotation.z = t * 0.25;
    ring2.rotation.y = -t * 0.2;
    particles.rotation.y = t * 0.04;
    group.position.x = 1.2 + mx * 0.35;
    group.position.y = 0.2 - my * 0.2;
    crystalMat.emissiveIntensity = 0.28 + Math.sin(t * 2) * 0.12;
    renderer.render(scene, camera);
    requestAnimationFrame(animate);
  }
  animate();
}
