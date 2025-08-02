# 🎨 Visualisations Exhaustives : Services Kubernetes

## 🎯 Introduction

Ce document présente une **approche visuelle complète** pour comprendre les services Kubernetes. Chaque diagramme illustre les concepts, architectures, flux et comparaisons entre les différents types de services.

### 📊 Vue d'ensemble complète

```mermaid
graph TB
    subgraph "🌐 Internet/Clients Externes"
        Client["👤 Client Web"]
        API_Client["🤖 Client API"]
        Mobile["📱 App Mobile"]
    end

    subgraph "☁️ Cloud Provider Infrastructure"
        CloudLB1["⚖️ Cloud LoadBalancer 1\n\$18/mois"]
        CloudLB2["⚖️ Cloud LoadBalancer 2\n\$18/mois"]
        CloudLB_Ingress["⚖️ Cloud LoadBalancer\npour Ingress\n\$18/mois"]
    end

    subgraph "🖥️ Cluster Kubernetes"
        subgraph "🚪 Ingress Layer (Solution Moderne)"
            IngressController["🎯 Ingress Controller\nNGINX/Traefik/Istio"]
            IngressRules["📋 Ingress Rules\nSSL + Routing"]
        end

        subgraph "🔗 Services Layer"
            subgraph "Production Services"
                LB_Service1["⚖️ LoadBalancer Service\nFrontend Production"]
                LB_Service2["⚖️ LoadBalancer Service\nAPI Production"]
                ClusterIP_DB["🔒 ClusterIP Service\nDatabase (interne)"]
                ClusterIP_Cache["🔒 ClusterIP Service\nRedis Cache (interne)"]
            end

            subgraph "Development Services"
                NodePort_Dev["🚪 NodePort Service\nDevelopment\nPort: 31200"]
            end
        end

        subgraph "📦 Pods Layer"
            subgraph "Frontend Tier"
                Frontend_Pod1["🎨 Frontend Pod 1\nReact/Vue/Angular"]
                Frontend_Pod2["🎨 Frontend Pod 2\nReact/Vue/Angular"]
            end

            subgraph "Backend Tier"
                API_Pod1["🔧 API Pod 1\nNode.js/Python/Go"]
                API_Pod2["🔧 API Pod 2\nNode.js/Python/Go"]
                API_Pod3["🔧 API Pod 3\nNode.js/Python/Go"]
            end

            subgraph "Data Tier"
                DB_Pod["🗄️ Database Pod\nPostgreSQL/MongoDB"]
                Cache_Pod["⚡ Cache Pod\nRedis/Memcached"]
            end

            subgraph "Development Tier"
                Dev_Pod["🛠️ Dev Pod\nTest Environment"]
            end
        end
    end

    subgraph "💻 Development Environment"
        Developer["👨‍💻 Développeur"]
        Kind["🐳 Kind/Minikube\navec extraPortMappings"]
    end

    %% Connexions Production LoadBalancer
    Client -->|HTTPS:443| CloudLB1
    API_Client -->|HTTPS:443| CloudLB2
    CloudLB1 --> LB_Service1
    CloudLB2 --> LB_Service2

    %% Connexions Production Ingress (Recommandé)
    Mobile -->|HTTPS:443| CloudLB_Ingress
    CloudLB_Ingress --> IngressController
    IngressController --> IngressRules
    IngressRules -->|www.app.com| LB_Service1
    IngressRules -->|api.app.com| LB_Service2

    %% Connexions Development
    Developer -->|localhost:31200| Kind
    Kind -->|Port Mapping| NodePort_Dev

    %% Services vers Pods
    LB_Service1 --> Frontend_Pod1
    LB_Service1 --> Frontend_Pod2
    LB_Service2 --> API_Pod1
    LB_Service2 --> API_Pod2
    LB_Service2 --> API_Pod3
    NodePort_Dev --> Dev_Pod

    %% Communication interne (ClusterIP)
    ClusterIP_DB --> DB_Pod
    ClusterIP_Cache --> Cache_Pod

    %% Communication inter-services
    API_Pod1 -.->|SQL| ClusterIP_DB
    API_Pod2 -.->|SQL| ClusterIP_DB
    API_Pod3 -.->|SQL| ClusterIP_DB
    API_Pod1 -.->|Cache| ClusterIP_Cache
    API_Pod2 -.->|Cache| ClusterIP_Cache
    API_Pod3 -.->|Cache| ClusterIP_Cache

    %% Styles
    classDef internet fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef cloud fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef ingress fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef service_prod fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef service_dev fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef service_internal fill:#fce4ec,stroke:#ad1457,stroke-width:2px
    classDef pod_frontend fill:#e0f2f1,stroke:#00695c,stroke-width:2px
    classDef pod_backend fill:#fff8e1,stroke:#ff8f00,stroke-width:2px
    classDef pod_data fill:#e8eaf6,stroke:#3f51b5,stroke-width:2px
    classDef dev fill:#f1f8e9,stroke:#558b2f,stroke-width:2px

    class Client,API_Client,Mobile internet
    class CloudLB1,CloudLB2,CloudLB_Ingress cloud
    class IngressController,IngressRules ingress
    class LB_Service1,LB_Service2 service_prod
    class NodePort_Dev service_dev
    class ClusterIP_DB,ClusterIP_Cache service_internal
    class Frontend_Pod1,Frontend_Pod2 pod_frontend
    class API_Pod1,API_Pod2,API_Pod3 pod_backend
    class DB_Pod,Cache_Pod pod_data
    class Dev_Pod,Developer,Kind dev
```


<br/>
<br/>

# 2 -  Comparaison Détaillée par Type

### 1. 🔒 ClusterIP - Communication Interne

```mermaid
graph LR
    subgraph "🔒 ClusterIP Service"
        subgraph "Caractéristiques"
            A1[🎯 IP interne uniquement<br/>10.96.x.x]
            A2[🔒 Pas d'accès externe]
            A3[💰 Gratuit]
            A4[🚀 Performance maximale]
        end
        
        subgraph "Cas d'usage"
            B1[🗄️ Bases de données]
            B2[⚡ Cache Redis]
            B3[🔧 APIs internes]
            B4[📊 Services de monitoring]
        end
        
        subgraph "Flux de trafic"
            C1[Pod A] --> C2[ClusterIP Service] --> C3[Pod B]
            C2 -.->|DNS| C4[service.namespace.svc.cluster.local]
        end
    end
    
    classDef clusterip fill:#fce4ec,stroke:#ad1457,stroke-width:2px
    classDef usage fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef flow fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    
    class A1,A2,A3,A4 clusterip
    class B1,B2,B3,B4 usage
    class C1,C2,C3,C4 flow
```

### 2. 🚪 NodePort - Développement

```mermaid
graph TB
    subgraph "🚪 NodePort Service"
        subgraph "Caractéristiques"
            A1[🎯 Port sur chaque nœud<br/>30000-32767]
            A2[🌐 Accès externe limité]
            A3[💰 Gratuit]
            A4[🛠️ Parfait pour dev/test]
        end
        
        subgraph "Configuration Kind"
            B1[📝 extraPortMappings requis]
            B2[🐳 Docker port mapping]
            B3[🔧 localhost:31200]
        end
        
        subgraph "Flux de trafic"
            C1[👨‍💻 Développeur] -->|localhost:31200| C2[Kind Docker]
            C2 -->|Port mapping| C3[NodePort Service]
            C3 --> C4[Pod Application]
            
            D1[🌐 Externe] -->|NODE-IP:31200| D2[Node]
            D2 --> D3[NodePort Service]
            D3 --> D4[Pod Application]
        end
    end
    
    classDef nodeport fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef kind fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef flow fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    
    class A1,A2,A3,A4 nodeport
    class B1,B2,B3 kind
    class C1,C2,C3,C4,D1,D2,D3,D4 flow
```

### 3. ⚖️ LoadBalancer - Production Cloud

```mermaid
graph TB
    subgraph "⚖️ LoadBalancer Service"
        subgraph "Caractéristiques"
            A1[🌐 IP publique automatique]
            A2[☁️ Intégration cloud native]
            A3[💰 ~$18/mois par LB]
            A4[🔒 SSL/TLS au load balancer]
        end
        
        subgraph "Intégrations Cloud"
            B1[🔶 AWS ALB/NLB/CLB]
            B2[🔷 Azure Load Balancer]
            B3[🔴 GCP Load Balancer]
            B4[⚙️ Annotations spécifiques]
        end
        
        subgraph "Flux de trafic"
            C1[🌐 Internet] -->|IP publique| C2[Cloud Load Balancer]
            C2 -->|Health checks| C3[LoadBalancer Service]
            C3 --> C4[Pod 1]
            C3 --> C5[Pod 2]
            C3 --> C6[Pod 3]
        end
        
        subgraph "Problème de coût"
            D1[Service 1: $18/mois]
            D2[Service 2: $18/mois]
            D3[Service 3: $18/mois]
            D4[💸 Total: $54/mois]
        end
    end
    
    classDef loadbalancer fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef cloud fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef flow fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef cost fill:#ffcdd2,stroke:#d32f2f,stroke-width:3px
    
    class A1,A2,A3,A4 loadbalancer
    class B1,B2,B3,B4 cloud
    class C1,C2,C3,C4,C5,C6 flow
    class D1,D2,D3,D4 cost
```

### 4. 🌐 Ingress - Solution Moderne

```mermaid
graph TB
    subgraph "🌐 Ingress - Solution Moderne"
        subgraph "Caractéristiques"
            A1[🎯 1 seul LoadBalancer]
            A2[🌐 Routage intelligent]
            A3[💰 $18/mois total]
            A4[🔒 SSL automatique]
            A5[⚡ Fonctionnalités avancées]
        end
        
        subgraph "Routage Avancé"
            B1[🌍 Par domaine<br/>api.app.com vs www.app.com]
            B2[📁 Par chemin<br/>/api/v1 vs /api/v2]
            B3[🎯 Par headers<br/>User-Agent, Authorization]
            B4[⚖️ Load balancing pondéré<br/>Canary deployments]
        end
        
        subgraph "Flux de trafic"
            C1[🌐 Internet] -->|HTTPS:443| C2[Cloud LoadBalancer<br/>$18/mois]
            C2 --> C3[Ingress Controller]
            C3 --> C4[Ingress Rules]
            C4 -->|www.app.com| C5[Frontend Service<br/>ClusterIP]
            C4 -->|api.app.com| C6[API Service<br/>ClusterIP]
            C4 -->|admin.app.com| C7[Admin Service<br/>ClusterIP]
            C5 --> C8[Frontend Pods]
            C6 --> C9[API Pods]
            C7 --> C10[Admin Pods]
        end
        
        subgraph "Économies"
            D1[🔶 Avant: 3 LoadBalancers<br/>3 × $18 = $54/mois]
            D2[✅ Après: 1 LoadBalancer + Ingress<br/>1 × $18 = $18/mois]
            D3[💰 Économie: $36/mois]
        end
    end
    
    classDef ingress fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef routing fill:#e8eaf6,stroke:#3f51b5,stroke-width:2px
    classDef flow fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef savings fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    
    class A1,A2,A3,A4,A5 ingress
    class B1,B2,B3,B4 routing
    class C1,C2,C3,C4,C5,C6,C7,C8,C9,C10 flow
    class D1,D2,D3 savings
```

---

## 📊 Matrice de Comparaison

### 🎯 Matrice Décisionnelle

```mermaid
graph TD
    A[🤔 Besoin d'exposer un service ?] --> B{Accès externe requis ?}
    
    B -->|Non| C[🔒 ClusterIP]
    C --> C1[✅ Communication interne<br/>🗄️ Bases de données<br/>⚡ Cache<br/>🔧 APIs internes]
    
    B -->|Oui| D{Quel environnement ?}
    
    D -->|🛠️ Développement<br/>Kind/Minikube| E[🚪 NodePort]
    E --> E1[✅ Accès rapide localhost<br/>🐳 Avec extraPortMappings<br/>💰 Gratuit<br/>🧪 Tests locaux]
    
    D -->|☁️ Production Cloud<br/>1 service simple| F[⚖️ LoadBalancer]
    F --> F1[✅ IP publique automatique<br/>🔒 SSL natif cloud<br/>💰 $18/mois<br/>⚡ Setup simple]
    
    D -->|☁️ Production Cloud<br/>Multiple services| G[🌐 Ingress]
    G --> G1[✅ 1 seul LoadBalancer<br/>🌍 Routage intelligent<br/>💰 $18/mois total<br/>🔒 SSL automatique<br/>⚡ Fonctionnalités avancées]
    
    D -->|🏢 On-premise| H{MetalLB disponible ?}
    H -->|Oui| I[⚖️ LoadBalancer + MetalLB]
    H -->|Non| J[🌐 Ingress Controller]
    
    classDef question fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef clusterip fill:#fce4ec,stroke:#ad1457,stroke-width:2px
    classDef nodeport fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef loadbalancer fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef ingress fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef result fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    
    class A,B,D,H question
    class C,C1 clusterip
    class E,E1 nodeport
    class F,F1,I loadbalancer
    class G,G1,J ingress
```

---

## 💰 Analyse des Coûts

### 📊 Comparaison des Coûts Mensuels

```mermaid
pie title Coûts Cloud par Type de Service
    "ClusterIP (Gratuit)" : 0
    "NodePort (Gratuit)" : 0
    "1 LoadBalancer" : 18
    "3 LoadBalancers" : 54
    "Ingress (1 LB total)" : 18
```

### 📈 Évolution des Coûts avec la Croissance

```mermaid
graph LR
    subgraph "Évolution des Coûts avec le Nombre de Services"
        A[1 Service] --> B[2 Services] --> C[3 Services] --> D[5 Services] --> E[10 Services]
        
        subgraph "LoadBalancer Traditionnel"
            A1[$18] --> B1[$36] --> C1[$54] --> D1[$90] --> E1[$180]
        end
        
        subgraph "Ingress Moderne"
            A2[$18] --> B2[$18] --> C2[$18] --> D2[$18] --> E2[$18]
        end
        
        subgraph "Économies avec Ingress"
            A3[$0] --> B3[$18] --> C3[$36] --> D3[$72] --> E3[$162]
        end
    end
    
    classDef cost_high fill:#ffcdd2,stroke:#d32f2f,stroke-width:2px
    classDef cost_stable fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef savings fill:#c8e6c9,stroke:#388e3c,stroke-width:3px
    
    class A1,B1,C1,D1,E1 cost_high
    class A2,B2,C2,D2,E2 cost_stable
    class A3,B3,C3,D3,E3 savings
```

---

## 🔄 Flux de Données Détaillés

### 1. 📡 Flux ClusterIP (Communication Interne)

```mermaid
sequenceDiagram
    participant FE as 🎨 Frontend Pod
    participant FESVC as 🔗 Frontend Service
    participant API as 🔧 API Pod
    participant APISVC as 🔗 API Service (ClusterIP)
    participant DB as 🗄️ Database Pod
    participant DBSVC as 🔗 DB Service (ClusterIP)
    
    Note over FE,DBSVC: Communication Interne Cluster
    
    FE->>APISVC: HTTP GET /api/users
    Note right of APISVC: DNS: api-service.namespace.svc.cluster.local
    APISVC->>API: Route vers pod sain
    
    API->>DBSVC: SELECT * FROM users
    Note right of DBSVC: DNS: db-service.namespace.svc.cluster.local
    DBSVC->>DB: Connexion PostgreSQL
    
    DB-->>DBSVC: Résultats SQL
    DBSVC-->>API: Données
    API-->>APISVC: JSON Response
    APISVC-->>FE: HTTP 200 + données
```

### 2. 🚪 Flux NodePort (Développement)

```mermaid
sequenceDiagram
    participant DEV as 👨‍💻 Développeur
    participant BROWSER as 🌐 Browser
    participant KIND as 🐳 Kind Docker
    participant NPSVC as 🚪 NodePort Service
    participant POD as 📦 Application Pod
    
    Note over DEV,POD: Développement Local avec Kind
    
    DEV->>BROWSER: Ouvre http://localhost:31200
    BROWSER->>KIND: HTTP GET localhost:31200
    Note right of KIND: extraPortMappings:<br/>hostPort:31200 → containerPort:31200
    
    KIND->>NPSVC: Forward vers NodePort Service
    Note right of NPSVC: NodePort: 31200<br/>Port: 80<br/>TargetPort: 8080
    
    NPSVC->>POD: Route vers application:8080
    
    POD-->>NPSVC: HTTP Response
    NPSVC-->>KIND: Response
    KIND-->>BROWSER: Response
    BROWSER-->>DEV: Page web affichée
```

### 3. ⚖️ Flux LoadBalancer (Production Cloud)

```mermaid
sequenceDiagram
    participant CLIENT as 👤 Client Internet
    participant CLOUDLB as ☁️ Cloud Load Balancer
    participant LBSVC as ⚖️ LoadBalancer Service
    participant POD1 as 📦 Pod 1
    participant POD2 as 📦 Pod 2
    participant POD3 as 📦 Pod 3
    
    Note over CLIENT,POD3: Production Cloud avec LoadBalancer
    
    CLIENT->>CLOUDLB: HTTPS GET https://app.example.com
    Note right of CLOUDLB: IP Publique: 203.0.113.100<br/>SSL Termination<br/>Health Checks
    
    CLOUDLB->>LBSVC: Forward vers service
    Note right of LBSVC: Load balancing algorithm<br/>Round-robin/Least connections
    
    alt Pod 1 is healthy
        LBSVC->>POD1: Route vers Pod 1
        POD1-->>LBSVC: Response
    else Pod 1 is down
        LBSVC->>POD2: Route vers Pod 2
        POD2-->>LBSVC: Response
    end
    
    LBSVC-->>CLOUDLB: Response
    CLOUDLB-->>CLIENT: HTTPS Response
```

### 4. 🌐 Flux Ingress (Production Moderne)

```mermaid
sequenceDiagram
    participant CLIENT as 👤 Client Internet
    participant CLOUDLB as ☁️ Cloud Load Balancer
    participant INGCTRL as 🎯 Ingress Controller
    participant INGRESS as 📋 Ingress Rules
    participant FESVC as 🔗 Frontend Service
    participant APISVC as 🔗 API Service
    participant FEPOD as 🎨 Frontend Pod
    participant APIPOD as 🔧 API Pod
    
    Note over CLIENT,APIPOD: Production Moderne avec Ingress
    
    par Frontend Request
        CLIENT->>CLOUDLB: GET https://www.example.com
        CLOUDLB->>INGCTRL: Forward request
        INGCTRL->>INGRESS: Check routing rules
        Note right of INGRESS: Host: www.example.com<br/>Path: /
        INGRESS->>FESVC: Route to frontend service
        FESVC->>FEPOD: Route to frontend pod
        FEPOD-->>FESVC: HTML response
        FESVC-->>INGRESS: Response
        INGRESS-->>INGCTRL: Response
        INGCTRL-->>CLOUDLB: Response
        CLOUDLB-->>CLIENT: HTTPS Response
    and API Request
        CLIENT->>CLOUDLB: GET https://api.example.com/users
        CLOUDLB->>INGCTRL: Forward request
        INGCTRL->>INGRESS: Check routing rules
        Note right of INGRESS: Host: api.example.com<br/>Path: /users
        INGRESS->>APISVC: Route to API service
        APISVC->>APIPOD: Route to API pod
        APIPOD-->>APISVC: JSON response
        APISVC-->>INGRESS: Response
        INGRESS-->>INGCTRL: Response
        INGCTRL-->>CLOUDLB: Response
        CLOUDLB-->>CLIENT: HTTPS Response
    end
```

---

## 🛡️ Patterns de Sécurité

### 🔒 Architecture de Sécurité Multi-Niveaux

```mermaid
graph TB
    subgraph "🛡️ Couches de Sécurité Kubernetes"
        subgraph "🌐 Périmètre Externe"
            WAF[🛡️ WAF/DDoS Protection]
            CloudLB[☁️ Cloud Load Balancer<br/>+ SSL Termination]
        end
        
        subgraph "🚪 Ingress Security"
            IngressController[🎯 Ingress Controller]
            AuthN[🔐 Authentication<br/>OAuth/OIDC]
            RateLimit[⏱️ Rate Limiting<br/>1000 req/min]
            CORS[🌍 CORS Policies]
        end
        
        subgraph "🔗 Service Mesh (Optionnel)"
            Istio[🕸️ Istio/Linkerd]
            mTLS[🔒 Mutual TLS]
            PolicyEngine[📋 Policy Engine]
        end
        
        subgraph "🖧 Network Policies"
            NetworkPolicy[🚧 Network Policies]
            Firewall[🔥 Pod-to-Pod Firewall]
            Segmentation[🏗️ Network Segmentation]
        end
        
        subgraph "🔐 Pod Security"
            RBAC[👤 RBAC]
            PSP[🛡️ Pod Security Policies]
            Secrets[🔑 Secrets Management]
        end
    end
    
    Internet[🌐 Internet] --> WAF
    WAF --> CloudLB
    CloudLB --> IngressController
    IngressController --> AuthN
    AuthN --> RateLimit
    RateLimit --> CORS
    CORS --> Istio
    Istio --> mTLS
    mTLS --> PolicyEngine
    PolicyEngine --> NetworkPolicy
    NetworkPolicy --> Firewall
    Firewall --> Segmentation
    Segmentation --> RBAC
    RBAC --> PSP
    PSP --> Secrets
    
    classDef perimeter fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef ingress fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef mesh fill:#e8eaf6,stroke:#3f51b5,stroke-width:2px
    classDef network fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef pod fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    
    class WAF,CloudLB perimeter
    class IngressController,AuthN,RateLimit,CORS ingress
    class Istio,mTLS,PolicyEngine mesh
    class NetworkPolicy,Firewall,Segmentation network
    class RBAC,PSP,Secrets pod
```

---

## 🚀 Patterns de Déploiement

### 1. 🔄 Blue-Green Deployment

```mermaid
graph TB
    subgraph "🔄 Blue-Green Deployment Pattern"
        subgraph "🌐 Load Balancer"
            LB[⚖️ Load Balancer<br/>IP Publique]
        end
        
        subgraph "🔗 Service Principal"
            MainService[📋 Main Service<br/>Selector: version=blue]
        end
        
        subgraph "💙 Environment Blue (Production)"
            BlueService[💙 Blue Service<br/>version=blue]
            BluePod1[💙 Blue Pod 1<br/>v1.0.0]
            BluePod2[💙 Blue Pod 2<br/>v1.0.0]
            BluePod3[💙 Blue Pod 3<br/>v1.0.0]
        end
        
        subgraph "💚 Environment Green (Standby)"
            GreenService[💚 Green Service<br/>version=green]
            GreenPod1[💚 Green Pod 1<br/>v1.1.0]
            GreenPod2[💚 Green Pod 2<br/>v1.1.0]
            GreenPod3[💚 Green Pod 3<br/>v1.1.0]
        end
        
        subgraph "🧪 Tests"
            TestSuite[🧪 Test Suite<br/>Validation v1.1.0]
        end
        
        subgraph "🔄 Switch Process"
            Switch[🔄 kubectl patch service<br/>selector: version=green]
        end
    end
    
    LB --> MainService
    MainService -->|100% traffic| BlueService
    MainService -.->|0% traffic| GreenService
    
    BlueService --> BluePod1
    BlueService --> BluePod2
    BlueService --> BluePod3
    
    GreenService --> GreenPod1
    GreenService --> GreenPod2
    GreenService --> GreenPod3
    
    TestSuite -.-> GreenService
    Switch -.-> MainService
    
    classDef lb fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef service fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef blue fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef green fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef test fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef switch fill:#fff8e1,stroke:#f57c00,stroke-width:2px
    
    class LB lb
    class MainService service
    class BlueService,BluePod1,BluePod2,BluePod3 blue
    class GreenService,GreenPod1,GreenPod2,GreenPod3 green
    class TestSuite test
    class Switch switch
```

### 2. 🕊️ Canary Deployment avec Ingress

```mermaid
graph TB
    subgraph "🕊️ Canary Deployment avec Ingress"
        subgraph "🌐 Internet"
            Users[👥 100 Utilisateurs]
        end
        
        subgraph "🎯 Ingress Controller"
            MainIngress[📋 Main Ingress<br/>90% traffic]
            CanaryIngress[🕊️ Canary Ingress<br/>10% traffic<br/>nginx.ingress.kubernetes.io/canary: true<br/>nginx.ingress.kubernetes.io/canary-weight: 10]
        end
        
        subgraph "📊 Distribution du Trafic"
            Stable90[📊 90 utilisateurs<br/>Version Stable]
            Canary10[🕊️ 10 utilisateurs<br/>Version Canary]
        end
        
        subgraph "🔗 Services"
            StableService[🔒 Service Stable<br/>version=v1.0.0]
            CanaryService[🕊️ Service Canary<br/>version=v1.1.0]
        end
        
        subgraph "📦 Pods"
            StablePods[📦 Stable Pods<br/>v1.0.0 (3 replicas)]
            CanaryPods[📦 Canary Pods<br/>v1.1.0 (1 replica)]
        end
        
        subgraph "📊 Monitoring"
            Metrics[📊 Metrics<br/>Error Rate, Latency<br/>Business KPIs]
            Alerts[🚨 Alerts<br/>Rollback if issues]
        end
    end
    
    Users --> MainIngress
    Users --> CanaryIngress
    
    MainIngress --> Stable90
    CanaryIngress --> Canary10
    
    Stable90 --> StableService
    Canary10 --> CanaryService
    
    StableService --> StablePods
    CanaryService --> CanaryPods
    
    StablePods --> Metrics
    CanaryPods --> Metrics
    Metrics --> Alerts
    
    classDef users fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef ingress fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef traffic fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef stable fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef canary fill:#fff8e1,stroke:#ff8f00,stroke-width:2px
    classDef monitoring fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    
    class Users users
    class MainIngress,CanaryIngress ingress
    class Stable90,Canary10 traffic
    class StableService,StablePods stable
    class CanaryService,CanaryPods canary
    class Metrics,Alerts monitoring
```

---

## 🔄 Migration Between Service Types

### 📈 Évolution des Services selon la Maturité

```mermaid
gitgraph
    commit id: "🛠️ Dev: NodePort"
    
    branch staging
    checkout staging
    commit id: "🧪 Staging: LoadBalancer"
    commit id: "🔒 Add SSL"
    
    checkout main
    merge staging
    commit id: "🚀 Prod: Single LoadBalancer"
    
    branch microservices
    checkout microservices
    commit id: "🔧 Add API Service"
    commit id: "🗄️ Add Database Service"
    commit id: "⚡ Add Cache Service"
    
    checkout main
    merge microservices
    commit id: "💸 Problem: Multiple LoadBalancers"
    commit id: "🌐 Solution: Migrate to Ingress"
    commit id: "💰 Cost Optimization Complete"
```

### 🔄 Stratégie de Migration Step-by-Step

```mermaid
graph TD
    subgraph "🔄 Migration Strategy: LoadBalancer → Ingress"
        subgraph "📊 Phase 1: Assessment"
            A1[📋 Audit current services]
            A2[💰 Calculate costs]
            A3[🎯 Plan ingress rules]
        end
        
        subgraph "🛠️ Phase 2: Preparation"
            B1[🎯 Install ingress controller]
            B2[🔒 Setup cert-manager]
            B3[📋 Create ingress configs]
            B4[🧪 Test in staging]
        end
        
        subgraph "🚀 Phase 3: Migration"
            C1[🕊️ Start with 1 service]
            C2[📊 Monitor metrics]
            C3[✅ Validate functionality]
            C4[🔄 Migrate remaining services]
        end
        
        subgraph "🧹 Phase 4: Cleanup"
            D1[🗑️ Remove old LoadBalancers]
            D2[💰 Verify cost savings]
            D3[📚 Update documentation]
            D4[🎓 Train team]
        end
    end
    
    A1 --> A2 --> A3
    A3 --> B1 --> B2 --> B3 --> B4
    B4 --> C1 --> C2 --> C3 --> C4
    C4 --> D1 --> D2 --> D3 --> D4
    
    classDef assessment fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef preparation fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef migration fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef cleanup fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    
    class A1,A2,A3 assessment
    class B1,B2,B3,B4 preparation
    class C1,C2,C3,C4 migration
    class D1,D2,D3,D4 cleanup
```

---

## 📊 Tableau de Bord Monitoring

### 🎯 KPIs par Type de Service

```mermaid
graph TB
    subgraph "📊 Dashboard Monitoring Services Kubernetes"
        subgraph "🔒 ClusterIP Metrics"
            CIP1[📈 Latency interne<br/>< 1ms]
            CIP2[🎯 Success Rate<br/>> 99.9%]
            CIP3[🔗 Connection Pool<br/>Utilisation]
            CIP4[🗄️ Database Connections<br/>Active/Idle]
        end
        
        subgraph "🚪 NodePort Metrics"
            NP1[🛠️ Dev Environment<br/>Response Time]
            NP2[🐳 Kind Cluster<br/>Health]
            NP3[🔌 Port Mapping<br/>Status]
            NP4[👨‍💻 Developer<br/>Experience]
        end
        
        subgraph "⚖️ LoadBalancer Metrics"
            LB1[🌐 Public IP<br/>Response Time]
            LB2[☁️ Cloud LB<br/>Health Checks]
            LB3[💰 Cost per Service<br/>$18/month]
            LB4[🔒 SSL Certificate<br/>Expiry]
        end
        
        subgraph "🌐 Ingress Metrics"
            ING1[🎯 Request Distribution<br/>Per Domain/Path]
            ING2[🔒 SSL Certificate<br/>Auto-renewal]
            ING3[⏱️ Rate Limiting<br/>Violations]
            ING4[💰 Total Cost<br/>$18/month]
            ING5[🕊️ Canary Traffic<br/>Distribution]
        end
        
        subgraph "🚨 Alerting Rules"
            ALT1[🔴 Critical: Service Down]
            ALT2[🟡 Warning: High Latency]
            ALT3[🟠 Info: Certificate Expiry]
            ALT4[🟣 Budget: Cost Increase]
        end
    end
    
    classDef clusterip fill:#fce4ec,stroke:#ad1457,stroke-width:2px
    classDef nodeport fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef loadbalancer fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef ingress fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef alerts fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    
    class CIP1,CIP2,CIP3,CIP4 clusterip
    class NP1,NP2,NP3,NP4 nodeport
    class LB1,LB2,LB3,LB4 loadbalancer
    class ING1,ING2,ING3,ING4,ING5 ingress
    class ALT1,ALT2,ALT3,ALT4 alerts
```

---

## 🎯 Conclusion Visuelle

### 🏆 Recommandations Finales

```mermaid
graph TB
    subgraph "🎯 Guide de Décision Final"
        subgraph "🛠️ Développement"
            DEV[🐳 Kind/Minikube]
            DEV --> DEV_REC[🚪 NodePort<br/>+ extraPortMappings<br/>✅ Simple et gratuit]
        end
        
        subgraph "🧪 Test/Staging"
            STAGE[☁️ Cloud Staging]
            STAGE --> STAGE_REC[🌐 Ingress<br/>+ SSL staging<br/>✅ Configuration proche prod]
        end
        
        subgraph "🚀 Production"
            PROD[☁️ Cloud Production]
            PROD --> PROD_CHOICE{Nombre de services ?}
            PROD_CHOICE -->|1 service| PROD_LB[⚖️ LoadBalancer<br/>✅ Simple setup]
            PROD_CHOICE -->|2+ services| PROD_ING[🌐 Ingress<br/>✅ Économique et scalable]
        end
        
        subgraph "🏢 On-Premise"
            ONPREM[🏢 Infrastructure On-Premise]
            ONPREM --> ONPREM_CHOICE{MetalLB disponible ?}
            ONPREM_CHOICE -->|Oui| ONPREM_LB[⚖️ LoadBalancer<br/>+ MetalLB]
            ONPREM_CHOICE -->|Non| ONPREM_ING[🌐 Ingress Controller<br/>+ NodePort fallback]
        end
        
        subgraph "💰 Optimisation Coûts"
            COST[💸 Optimisation Budget]
            COST --> COST_REC[🌐 Ingress = Meilleur ROI<br/>$18/mois vs $18×N/mois]
        end
        
        subgraph "🔒 Sécurité"
            SEC[🛡️ Exigences Sécurité]
            SEC --> SEC_REC[🌐 Ingress + Network Policies<br/>+ cert-manager + WAF]
        end
    end
    
    classDef dev fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef staging fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef prod fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef onprem fill:#e8eaf6,stroke:#3f51b5,stroke-width:2px
    classDef cost fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef security fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef recommendation fill:#c8e6c9,stroke:#388e3c,stroke-width:3px
    
    class DEV,DEV_REC dev
    class STAGE,STAGE_REC staging
    class PROD,PROD_CHOICE,PROD_LB,PROD_ING prod
    class ONPREM,ONPREM_CHOICE,ONPREM_LB,ONPREM_ING onprem
    class COST,COST_REC cost
    class SEC,SEC_REC security
```

---

## 📚 Ressources et Next Steps

Cette visualisation exhaustive vous donne une **vision complète** des services Kubernetes ! 

### 🎯 **Key Takeaways**

1. **🔒 ClusterIP** : Fondation pour la communication interne
2. **🚪 NodePort** : Parfait pour le développement (avec Kind/extraPortMappings)
3. **⚖️ LoadBalancer** : Production simple mais coûteux
4. **🌐 Ingress** : Solution moderne économique et puissante

### 🚀 **Next Steps Recommandés**

1. **Pratiquez** avec les exemples du cours
2. **Implémentez** Ingress en production  
3. **Optimisez** vos coûts cloud
4. **Maîtrisez** les patterns de déploiement avancés


**Vous avez maintenant une maîtrise visuelle complète des services Kubernetes ! 🎉**
