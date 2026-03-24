# vue3-devextreme — Claude Code Skill

Skill para Claude Code CLI que genera pantallas enterprise completas con
**Vue 3 + DevExtreme Vue + Pinia + TanStack Query + TypeScript**.

Inspecciona la base de datos conectada automáticamente para inferir
campos, tipos y relaciones sin que el desarrollador declare nada a mano.

---

## ¿Qué incluye?

| Archivo | Propósito | Se carga |
|---------|-----------|----------|
| `.claude/skills/vue3-devextreme/vue3-devextreme.md` | Generador de pantallas CRUD | Bajo demanda `/vue3-devextreme` |
| `.claude/rules/vue3-devextreme/dx-components.md` | Componentes DX, imports, theming | Automático en cada sesión |
| `.claude/rules/vue3-devextreme/state-and-data.md` | Pinia, TanStack Query, CustomStore | Automático en cada sesión |
| `.claude/rules/vue3-devextreme/performance.md` | Optimizaciones DxDataGrid y Vue | Automático en cada sesión |
| `.claude/rules/vue3-devextreme/code-quality.md` | Estructura, naming, arquitectura | Automático en cada sesión |
| `CLAUDE.md` | Índice que activa las rules | Copiar a raíz del proyecto |

---

## Instalación

Los scripts descargan el skill automáticamente y lo instalan en el proyecto actual.
Si ya tenés un `CLAUDE.md`, agregan las líneas al final sin sobreescribirlo.

Descargá el script correspondiente a tu sistema, colocalo en la raíz de tu proyecto y ejecutalo:

**Windows (PowerShell):**
```powershell
# Descargar
Invoke-WebRequest https://raw.githubusercontent.com/JulioGastonPita/vue3-devextreme-skill/master/install.ps1 -OutFile install.ps1
# Ejecutar desde la raíz de tu proyecto
.\install.ps1
```

**macOS / Linux:**
```bash
curl -O https://raw.githubusercontent.com/JulioGastonPita/vue3-devextreme-skill/master/install.sh
bash install.sh
```

El script hace todo solo:
1. Descarga el skill con `degit`
2. Copia `.claude/rules/vue3-devextreme/` y `.claude/skills/vue3-devextreme.md`
3. Crea o actualiza `CLAUDE.md`
4. Limpia los archivos temporales

---

## Uso rápido

### Proyecto nuevo desde cero

**macOS / Linux:**
```bash
npm create vue@latest mi-proyecto
cd mi-proyecto
npm install devextreme devextreme-vue pinia @tanstack/vue-query axios
curl -O https://raw.githubusercontent.com/JulioGastonPita/vue3-devextreme-skill/master/install.sh
bash install.sh
claude
```

**Windows (PowerShell):**
```powershell
npm create vue@latest mi-proyecto
cd mi-proyecto
npm install devextreme devextreme-vue pinia @tanstack/vue-query axios
Invoke-WebRequest https://raw.githubusercontent.com/JulioGastonPita/vue3-devextreme-skill/master/install.ps1 -OutFile install.ps1
.\install.ps1
claude
```

### Generar una pantalla

En Claude Code CLI escribir:

```
/vue3-devextreme
```

Claude pregunta la entidad, inspecciona la BD conectada, confirma el esquema
y genera los 4 archivos en orden:

```
src/services/productosApi.ts
src/queries/useProductos.ts
src/composables/useProductosGrid.ts
src/views/ProductosView.vue
```

---

## Monorepo

Si el proyecto es un monorepo con otros stacks (Go, PostgreSQL, etc.),
**no copiar el `CLAUDE.md` a la raíz global**. En su lugar crear un
`CLAUDE.md` por módulo:

```
monorepo/
├── CLAUDE.md              ← índice global neutro (sin @rules)
├── frontend/
│   ├── CLAUDE.md          ← copia de este CLAUDE.md
│   └── .claude/rules/     ← rules Vue+DX activas solo en frontend/
└── backend/
    └── CLAUDE.md          ← rules Go (sin contaminación de Vue)
```

---

## Desinstalación

**Windows (PowerShell):**
```powershell
Invoke-WebRequest https://raw.githubusercontent.com/JulioGastonPita/vue3-devextreme-skill/master/uninstall.ps1 -OutFile uninstall.ps1
.\uninstall.ps1
```

**macOS / Linux:**
```bash
curl -O https://raw.githubusercontent.com/JulioGastonPita/vue3-devextreme-skill/master/uninstall.sh
bash uninstall.sh
```

Los scripts eliminan:
- `.claude/rules/vue3-devextreme/`
- `.claude/skills/vue3-devextreme.md`
- El bloque de rules en `CLAUDE.md` (el resto del archivo no se toca)

---

## Estructura del repositorio

```
vue3-devextreme-skill/
├── README.md
├── CLAUDE.md
├── install.sh
├── install.ps1
├── uninstall.sh
├── uninstall.ps1
└── .claude/
    ├── skills/
    │   └── vue3-devextreme/
    │       └── vue3-devextreme.md   ← invocable con /vue3-devextreme
    └── rules/
        └── vue3-devextreme/         ← subcarpeta propia del skill
            ├── dx-components.md
            ├── state-and-data.md
            ├── performance.md
            └── code-quality.md
```

---

## Stack generado

| Capa | Tecnología |
|------|-----------|
| Framework | Vue 3 — Composition API `<script setup lang="ts">` |
| UI | DevExtreme Vue |
| Estado | Pinia (negocio) · TanStack Query (servidor) · `ref` (UI) |
| Lenguaje | TypeScript |
| HTTP | Axios |

---

## Pantalla generada por el skill

Cada invocación de `/vue3-devextreme` produce:

```
┌─────────────────────────────────────────┐
│  DxToolbar  (título + botón Nuevo)      │
├─────────────────────────────────────────┤
│  DxDataGrid  (CRUD con edición popup)   │
│  · Filtros, búsqueda, paginación        │
│  · Exportación                          │
│  · Lookups automáticos para FK          │
├─────────────────────────────────────────┤
│  DxPopup  (DxForm con validaciones)     │
│  · Campos inferidos de la BD            │
│  · Reglas según constraints de la tabla │
└─────────────────────────────────────────┘
```

---

## Requisitos

- Claude Code CLI instalado (`npm install -g @anthropic-ai/claude-code`)
- Node.js 18+
- Proyecto Vue 3 con Vite

---

## Licencia

MIT
