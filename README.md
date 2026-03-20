# vue3-devextreme — Claude Code Skill

Skill para Claude Code CLI que genera pantallas enterprise completas con
**Vue 3 + DevExtreme Vue + Pinia + TanStack Query + TypeScript**.

Inspecciona la base de datos conectada automáticamente para inferir
campos, tipos y relaciones sin que el desarrollador declare nada a mano.

---

## ¿Qué incluye?

| Archivo | Propósito | Se carga |
|---------|-----------|----------|
| `.claude/skills/vue3-devextreme/SKILL.md` | Generador de pantallas CRUD | Bajo demanda `/vue3-devextreme` |
| `.claude/rules/dx-components.md` | Componentes DX, imports, theming | Automático en cada sesión |
| `.claude/rules/state-and-data.md` | Pinia, TanStack Query, CustomStore | Automático en cada sesión |
| `.claude/rules/performance.md` | Optimizaciones DxDataGrid y Vue | Automático en cada sesión |
| `.claude/rules/code-quality.md` | Estructura, naming, arquitectura | Automático en cada sesión |
| `CLAUDE.md` | Índice que activa las rules | Copiar a raíz del proyecto |

---

## Instalación

### Opción A — npx skills (recomendada)

```bash
# Instalar en el proyecto actual
npx skills add TU-ORG/vue3-devextreme-skill --skill vue3-devextreme -a claude-code

# O instalar globalmente (disponible en todos los proyectos)
npx skills add TU-ORG/vue3-devextreme-skill --skill vue3-devextreme -a claude-code -g
```

Luego copiar el `CLAUDE.md` a la raíz del proyecto:

```bash
cp .claude/skills/vue3-devextreme/CLAUDE.md ./CLAUDE.md
```

### Opción B — npx add-skill (zero dependencias)

```bash
npx add-skill TU-ORG/vue3-devextreme-skill
cp .claude/skills/vue3-devextreme/CLAUDE.md ./CLAUDE.md
```

### Opción C — Plugin marketplace de Claude Code

```bash
# Agregar marketplace (una sola vez por máquina)
/plugin marketplace add TU-ORG/vue3-devextreme-skill

# Instalar desde Claude Code CLI
/plugin install vue3-devextreme@vue3-devextreme-skill
```

### Opción D — Instalación manual (sin npx)

```bash
git clone https://github.com/TU-ORG/vue3-devextreme-skill /tmp/vue3-dx
cp -r /tmp/vue3-dx/.claude ./
cp /tmp/vue3-dx/CLAUDE.md ./CLAUDE.md
```

---

## Uso rápido

### Proyecto nuevo desde cero

```bash
# 1. Crear proyecto Vue 3
npm create vue@latest mi-proyecto
cd mi-proyecto

# 2. Instalar dependencias del stack
npm install devextreme devextreme-vue pinia @tanstack/vue-query axios

# 3. Instalar el skill
npx skills add TU-ORG/vue3-devextreme-skill --skill vue3-devextreme -a claude-code
cp .claude/skills/vue3-devextreme/CLAUDE.md ./CLAUDE.md

# 4. Abrir Claude Code
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

Ver sección **Monorepo** en la documentación completa.

---

## Estructura del repositorio

```
vue3-devextreme-skill/
├── README.md
├── CLAUDE.md
└── .claude/
    ├── skills/
    │   └── vue3-devextreme/
    │       └── SKILL.md        ← invocable con /vue3-devextreme
    └── rules/
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
