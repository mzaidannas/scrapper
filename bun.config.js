import path from 'path';
import fs from 'fs';
import postcss from 'postcss';
import tailwindcss from '@tailwindcss/postcss';

const config = {
  sourcemap: "external",
  minify: true,
  entrypoints: ["app/javascript/application.js"],
  outdir: path.join(process.cwd(), "app/assets/builds"),
};

const buildCSS = async () => {
  const css = await Bun.file('app/assets/tailwind/application.css').text()

  const result = await postcss([
    tailwindcss({
      optimize: true
    })
  ]).process(css, {
    from: 'app/assets/tailwind/application.css',
    to: 'app/assets/builds/tailwind.css',
  })

  await Bun.write('app/assets/builds/tailwind.css', result.css)
};

const build = async (config) => {
  const result = await Bun.build(config);

  if (!result.success) {
    if (process.argv.includes('--watch')) {
      console.error("Build failed");
      for (const message of result.logs) {
        console.error(message);
      }
      return;
    } else {
      throw new AggregateError(result.logs, "Build failed");
    }
  }
};

(async () => {
  await build(config);
  await buildCSS();

  if (process.argv.includes('--watch')) {
    fs.watch(path.join(process.cwd(), "app/javascript"), { recursive: true }, (eventType, filename) => {
      console.log(`File changed: ${filename}. Rebuilding...`);
      build(config);
      buildCSS();
    });
  } else {
    process.exit(0);
  }
})();
