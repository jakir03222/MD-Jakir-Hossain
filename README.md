# Biddabari Course Discovery (Flutter Test)

Flutter course listing module built for the Biddabari Mobile Application Developer technical test.

## Features

### Question 1
- Live API: `GET https://api.biddabari.com/api/v1/app-home-courses`
- Reusable `CourseCard` (cached banner, title, subtitle, discount price, stats)
- GetX reactive states: Loading / Success / Empty / Error
- No `FutureBuilder` / `setState`
- Feature-first folders: `binding` / `data` / `logic` / `presentation`

### Question 2
- Per-card live discount countdown (ticks every second without rebuilding the list)
- Offline-first cache with **GetStorage**
- Connectivity banner + auto-retry with **connectivity_plus**
- Pull-to-refresh
- GetX named routes + Hero banner animation to Course Details

## Run

```bash
flutter pub get
flutter run
```

## Architecture (SOLID + OOP)

Feature-first MVC with interfaces (`abstract class`) and DI via GetX:

| Principle | How applied |
|-----------|-------------|
| **S** | Model = JSON only; datasources = remote/local; evaluator = discount rules |
| **O** | `IDiscountStrategy` + factory — new discount types without changing callers |
| **L** | Implementations swap behind `ICourseRepository`, `IApiClient`, etc. |
| **I** | Small contracts: remote DS, local DS, connectivity, storage, clock |
| **D** | `CourseController` depends on `ICourseRepository` / `IConnectivityService` / `IClock` |

```text
lib/
├── core/
│   ├── network/     IApiClient, IConnectivityService
│   ├── storage/     ILocalStorage
│   ├── time/        IClock
│   ├── constants/
│   └── routes/
└── features/courses/
    ├── binding/          abstracts → implementations
    ├── data/
    │   ├── datasources/  ICourseRemote/LocalDataSource
    │   ├── discount/     IDiscountStrategy, IDiscountEvaluator
    │   ├── models/
    │   └── repository/   ICourseRepository
    ├── logic/
    └── presentation/
```
