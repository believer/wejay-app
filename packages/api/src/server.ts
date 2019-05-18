import { GraphQLServer } from 'graphql-yoga'
import gql from 'graphql-tag'
import { Sonos } from 'sonos'

const device = new Sonos('192.168.0.8')

const typeDefs = gql`
  interface Track {
    album: String!
    artist: String!
    title: String!
  }

  type CurrentTrack implements Track {
    # Inherited from Track
    album: String!
    artist: String!
    title: String!

    # Custom
    position: Int!
    duration: Int!
    queuePosition: Int!
    albumArtURL: String
  }

  type QueueTrack implements Track {
    # Inherited from Track
    album: String!
    artist: String!
    title: String!
    albumArtURI: String
  }

  type Query {
    currentTrack: CurrentTrack
    hasNext: Boolean!
    hasPrevious: Boolean!
    isPlaying: Boolean!
    upcomingTracks: [QueueTrack]!
  }

  type Mutation {
    next: CurrentTrack
    previous: CurrentTrack
    togglePlaying: Boolean!
  }
`

const resolvers = {
  Query: {
    hasNext: async () => {
      const queue = await device.getQueue()
      const nowPlaying = await device.currentTrack()

      return queue.items.slice(nowPlaying.queuePosition).length > 0
    },
    hasPrevious: async () => {
      const nowPlaying = await device.currentTrack()

      return nowPlaying.queuePosition !== 1
    },
    currentTrack: async () => {
      const track = await device.currentTrack()

      if (track.queuePosition === 0) {
        return null
      }

      return track
    },

    upcomingTracks: async () => {
      const queue = await device.getQueue()
      const nowPlaying = await device.currentTrack()

      return queue.items.slice(nowPlaying.queuePosition)
    },

    isPlaying: async () => {
      const state = await device.getCurrentState()

      return state === 'playing'
    },
  },

  Mutation: {
    next: async () => {
      await device.next()
      const track = await device.currentTrack()

      return track
    },
    previous: async () => {
      await device.previous()
      const track = await device.currentTrack()

      return track
    },
    togglePlaying: async () => {
      await device.togglePlayback()
      const state = await device.getCurrentState()

      return state === 'playing'
    },
  },
}

const server = new GraphQLServer({ typeDefs, resolvers })

server.start(() => console.log('Server is running on localhost:4000'))
