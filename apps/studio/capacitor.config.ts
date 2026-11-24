import type { CapacitorConfig } from '@capacitor/cli'

const config: CapacitorConfig = {
  appId: 'com.yousivar.aistudio',
  appName: 'YOUSIVAR AI Studio',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  }
}

export default config
