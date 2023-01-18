import { Application } from '@hotwired/stimulus';

export {};

declare global {
  interface Window {
    Stimulus: Application;
  }
}
